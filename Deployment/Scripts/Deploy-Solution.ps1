[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $Location,
    [Parameter(Mandatory = $true)]
    [string]
    $DataverseEnvironmentId,
    [Parameter(Mandatory = $true)]
    [string]
    $WelcomePackageUrl,
    [Parameter(Mandatory = $false)]
    [string]
    $SubscriptionId = "",
    [Parameter(Mandatory = $false)]
    [string]
    $ResourceGroupName = "rg-ProvisionGenie",
    [Parameter(Mandatory = $false)]
    [string]
    $AadAppName = "ProvisionGenieApp"
)

if ($SubscriptionId -ne "") {
    az account set -s $SubscriptionId
    if (!$?) { 
        Write-Error "Unable to select $SubscriptionId as the active subscription."
        exit 1
    }
    Write-Host "Active Subscription set to $SubscriptionId"
} else {
    $Subscription = az account show | ConvertFrom-Json
    $SubscriptionId = $Subscription.id
    $SubscriptionName = $Subscription.name
    Write-Host "Active Subscription is $SubscriptionId ($SubscriptionName)"
}

Write-Host "Validating deployment location"
$ValidateLocation = az account list-locations --query "[?name=='$Location']" | ConvertFrom-Json
if ($ValidateLocation.Count -eq 0) {
    Write-Error "The location provided is not valid, the available locations for your account are:"
    az account list-locations --query [].name
    exit 1
}

$appId = az ad app list --query "[?displayName=='$AadAppName'].appId | [0]"
if ($null -eq $appId) {
    Write-Error "$AadAppName does not exist. Double check that you have run Create-AadAppRegistration.ps1 as documented before deploying the Dataverse tables and running this script."
    exit 1
} else {
    Write-Host "Removing old client secrets from $AadAppName"
    az ad app credential list --id $appId --query [].keyId | ConvertFrom-Json | ForEach-Object {
        az ad app credential delete --id $appId --key-id $_
    }
}
Write-Host "Generating ClientSecret for AzureAD application"
$sp = az ad app credential reset --id $appId --append | ConvertFrom-Json

Write-Host "Creating Resource Group"
$MainResourceGroup = az group create `
    --name $ResourceGroupName `
    --location $Location

Write-Host "Ensuring current user has contributor permissions to $ResourceGroupName resource group"

$me = az ad signed-in-user show | ConvertFrom-Json
$roleAssignments = az role assignment list --all --assignee $me.objectId --query "[?resourceGroup=='$ResourceGroupName' && roleDefinitionName=='Contributor'].roleDefinitionName" | ConvertFrom-Json
if ($roleAssignments.Count -eq 0) {
    Write-Host "Current user does not have contributor permissions to $ResourceGroupName resource group, attempting to assign contributor permissions"
    az role assignment create --assignee $me.objectId --role contributor --resource-group $ResourceGroupName
}


$DeployTimestamp = (Get-Date).ToUniversalTime().ToString("yyyyMMdTHmZ")
# Deploy
az deployment group create `
    --name "DeployLinkedTemplate-$DeployTimestamp" `
    --resource-group $ResourceGroupName `
    --template-file ../bicep/ProvisionGenie-root.bicep `
    --parameters DataverseEnvironmentId=$DataverseEnvironmentId `
                WelcomePackageUrl=$WelcomePackageUrl `
                servicePrincipal_AppId=$($sp.appId) `
                servicePrincipal_ClientSecret=$($sp.password) `
                servicePrincipal_TenantId=$($sp.tenant) `
    --verbose

if (!$?) { 
    Write-Error "An error occured during the ARM deployment."
    exit 1
}

Write-Host "Azure Logic Apps deployed, granting permissions to ProvisionGenie-ManagedIdentity"

# get the Managed Identity principal ID
$ManagedIdentity = az identity show --name ProvisionGenie-ManagedIdentity --resource-group $ResourceGroupName | ConvertFrom-Json

$principalId = $ManagedIdentity.principalId
# Get current role assignments
$currentRoles = (az rest `
    --method get `
    --uri https://graph.microsoft.com/v1.0/servicePrincipals/$principalId/appRoleAssignments `
    | ConvertFrom-Json).value `
    | ForEach-Object { $_.appRoleId }

$graphResourceId = az ad sp list --display-name "Microsoft Graph" --query [0].objectId
#Get appRoleIds for Team.Create, Group.ReadWrite.All, Directory.ReadWrite.All, Group.Create, Sites.Manage.All, Sites.ReadWrite.All
$graphId = az ad sp list --query "[?appDisplayName=='Microsoft Graph'].appId | [0]" --all
$teamCreate = az ad sp show --id $graphId --query "appRoles[?value=='Team.Create'].id | [0]" -o tsv
$readWriteAll = az ad sp show --id $graphId --query "appRoles[?value=='Group.ReadWrite.All'].id | [0]" -o tsv
$directoryReadWriteAll = az ad sp show --id $graphId --query "appRoles[?value=='Directory.ReadWrite.All'].id | [0]" -o tsv
$groupCreate = az ad sp show --id $graphId --query "appRoles[?value=='Group.Create'].id | [0]" -o tsv
$sitesManageAll = az ad sp show --id $graphId --query "appRoles[?value=='Sites.Manage.All'].id | [0]" -o tsv
$sitesReadWriteAll = az ad sp show --id $graphId --query "appRoles[?value=='Sites.ReadWrite.All'].id | [0]" -o tsv
$teamMemberReadWriteAll = az ad sp show --id $graphId --query "appRoles[?value=='TeamMember.ReadWrite.All'].id | [0]" -o tsv 
$appRoleIds = $teamCreate, $readWriteAll, $directoryReadWriteAll, $groupCreate, $sitesManageAll, $sitesReadWriteAll, $teamMemberReadWriteAll
#Loop over all appRoleIds
foreach ($appRoleId in $appRoleIds) {
    $roleMatch = $currentRoles -match $appRoleId
    if ($roleMatch.Length -eq 0) {
        # Add the role assignment to the principal
        $body = "{'principalId':'$principalId','resourceId':'$graphResourceId','appRoleId':'$appRoleId'}";
        az rest `
            --method post `
            --uri https://graph.microsoft.com/v1.0/servicePrincipals/$principalId/appRoleAssignments `
            --body $body `
            --headers Content-Type=application/json 
    }
}

Write-Host "Done"
