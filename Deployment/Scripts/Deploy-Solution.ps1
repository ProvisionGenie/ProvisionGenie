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
    $ResourceGroupName = "ProvisionGenie"
)
# Stop processing if errors occur
$ErrorActionPreference = "Stop"

if ($SubscriptionId -ne "") {
    az account set -s $SubscriptionId
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
    az account list-locations
    exit 1
}

$driveInfo = Get-CloudDrive
$StorageAccountName = $driveInfo.StorageAccountName
$UrlBase = "https:" + $driveInfo.FileSharePath

Write-Host "Validating current directory is in clouddrive"
if (!$pwd.Path.StartsWith($driveInfo.MountPoint)) {
    Write-Error "Please ensure that you cd into the clouddrive directory before cloning the project so that the ARM templates can be accessed with a SAS Token via a URL for deployment."
    exit 1
}

Write-Host "Ensuring current user has contributor permissions to clouddrive storage account"
# Ensure that the current user has the Contributor role for the storage account
$me = az ad signed-in-user show | ConvertFrom-Json
$StorageAccountId = az storage account show -g $driveInfo.ResourceGroupName -n $driveInfo.StorageAccountName --query id
$roleAssignments = az role assignment list --all --assignee $me.objectId --query "[?scope=='$StorageAccountId' && roleDefinitionName=='Contributor'].roleDefinitionName" | ConvertFrom-Json
if ($roleAssignments.Count -eq 0) {
    Write-Host "Current user does not have contributor permissions to clouddrive storage account, attempting to assign contributor permissions"
    az role assignment create --assignee $me.objectId --role contributor --scope $StorageAccountId
}

$appId = az ad app list --query "[?displayName=='ProvisionGenieApp'].appId | [0]"
if ($null -eq $appId) {
    Write-Host "Creating AzureAD application"
    $app = az ad app create --display-name ProvisionGenieApp --available-to-other-tenants false | ConvertFrom-Json
    $appId = $app.appId
    Write-Host "Assigning AzureAD application permissions"
    az ad app permission add --id $appid --api 00000007-0000-0000-c000-000000000000 --api-permissions 78ce3f0f-a1ce-49c2-8cde-64b5c0896db4=Scope
    az ad sp create --id $appid
    az ad app permission grant --id $appid --api 00000007-0000-0000-c000-000000000000
} else {
    Write-Host "Removing old client secrets from ProvisionGenieApp"
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

Write-Host "Getting access key for storage account $StorageAccountName"
$Key = az storage account keys list `
    --account-name $StorageAccountName `
    --resource-group $driveInfo.ResourceGroupName `
    --query "[0].value"

# Set up an expriy for the SAS Token
$Expiry = (Get-Date).AddHours(1).ToUniversalTime().ToString("yyyy-MM-dTH:mZ")
Write-Host "Creating read-only SAS Token for container expiring at $Expiry"
$SasToken = az storage account generate-sas `
    --account-name $StorageAccountName `
    --https-only `
    --permissions r `
    --services f `
    --resource-types o `
    --expiry $Expiry `
    --account-key $Key

$ArmTemplateFolderUrl = $pwd.Path.Replace($driveInfo.MountPoint, $UrlBase).Replace("Scripts", "ARM")
$MainTemplateUri = $armTemplateFolderUrl + "/ARM-template.json"

$DeployTimestamp = (Get-Date).ToUniversalTime().ToString("yyyyMMdTHmZ")
# Deploy
az deployment group create `
  --name "DeployLinkedTemplate-$DeployTimestamp" `
  --resource-group $ResourceGroupName `
  --template-uri $MainTemplateUri `
  --query-string $SasToken `
  --parameters subscriptionId=$SubscriptionId `
                DataverseEnvironmentId=$DataverseEnvironmentId `
                resourceGroupName=$ResourceGroupName `
                WelcomePackageUrl=$WelcomePackageUrl `
                servicePrincipal_AppId=$sp.appId `
                servicePrincipal_ClientSecret=$sp.clientSecret `
                servicePrincipal_TenantId=$sp.tenantId `
  --verbose

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
$teamCreate = az ad sp show --id $graphId --query "appRoles[?value=='Team.Create'].id | [0]"
$readWriteAll = az ad sp show --id $graphId --query "appRoles[?value=='Group.ReadWrite.All'].id | [0]"
$directoryReadWriteAll = az ad sp show --id $graphId --query "appRoles[?value=='Directory.ReadWrite.All'].id | [0]"
$groupCreate = az ad sp show --id $graphId --query "appRoles[?value=='Group.Create'].id | [0]"
$sitesManageAll = az ad sp show --id $graphId --query "appRoles[?value=='Sites.Manage.All'].id | [0]"
$sitesReadWriteAll = az ad sp show --id $graphId --query "appRoles[?value=='Sites.ReadWrite.All'].id | [0]"
$appRoleIds = $teamCreate, $readWriteAll, $directoryReadWriteAll, $groupCreate, $sitesManageAll, $sitesReadWriteAll
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
