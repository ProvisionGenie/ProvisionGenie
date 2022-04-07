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
    Write-Host "Creating service principal"
    az ad sp create --id $appId

} else {
    Write-Host "$AadAppName already exists"
}
