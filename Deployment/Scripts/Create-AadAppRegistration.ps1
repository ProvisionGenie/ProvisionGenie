[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]
    $SubscriptionId = "",
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

$appId = az ad app list --query "[?displayName=='$AadAppName'].appId | [0]"
if ($null -eq $appId) {
    Write-Host "Creating AzureAD application"
    $app = az ad app create --display-name $AadAppName --available-to-other-tenants false | ConvertFrom-Json
    $appId = $app.appId
    Write-Host "Assigning AzureAD application permissions"
    az ad app permission add --id $appid --api 00000007-0000-0000-c000-000000000000 --api-permissions 78ce3f0f-a1ce-49c2-8cde-64b5c0896db4=Scope
    az ad sp create --id $appid
    az ad app permission grant --id $appid --api 00000007-0000-0000-c000-000000000000
} else {
    Write-Host "$AadAppName already exists"
}

