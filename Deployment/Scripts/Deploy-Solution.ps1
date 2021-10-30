[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $Location,
    [Parameter(Mandatory = $true)]
    [string]
    $StorageAccountName,
    [Parameter(Mandatory = $true)]
    [string]
    $DataverseEnvironmentId,
    [Parameter(Mandatory = $true)]
    [string]
    $WelcomePackageUrl,
    [Parameter(Mandatory = $false)]
    [string]
    $SubscriptionId = ""
)

$ResourceGroupName = "ProvisionGenie"

if ($SubscriptionId -ne "") {
    az account set -s $SubscriptionId
    Write-Host "Active Subscription set to $SubscriptionId"
} else {
    $Subscription = az account show | ConvertFrom-Json
    $SubscriptionId = $Subscription.id
    $SubscriptionName = $Subscription.name
    Write-Host "Active Subscription is $SubscriptionId ($SubscriptionName)"
}
# check the location provided is valid
$ValidateLocation = az account list-locations --query "[?name=='$Location']" | ConvertFrom-Json
if ($ValidateLocation.Count -eq 0) {
    Write-Error "The location provided is not valid, the available locations for your account are:"
    az account list-locations
    exit 1
}

Write-Host "Creating Resource Groups"
$MainResourceGroup = az group create `
    --name $ResourceGroupName `
    --location $Location
$DeployResourceGroupName = $ResourceGroupName + "-deploy"
$DeployResourceGroup = az group create `
    --name $DeployResourceGroupName `
    --location $Location

Write-Host "Creating storage account $StorageAccountName"
$StorageAccount = az storage account create `
    --name $StorageAccountName `
    --resource-group $DeployResourceGroupName `
    --location $Location `
    --sku Standard_LRS | ConvertFrom-Json
Write-Host "Getting access key for storage account $StorageAccountName"
$Key = az storage account keys list `
    --account-name $StorageAccountName `
    --resource-group $DeployResourceGroupName `
    --query "[0].value"

$DeployContainerName = "templates"
Write-Host "Creating storage container $DeployContainerName in $StorageAccountName"
$Container = az storage container create `
    --name $DeployContainerName `
    --account-name $StorageAccountName `
    --auth-mode login

# Set up an expriy for the SAS Token
$Expiry = (Get-Date).AddHours(1).ToUniversalTime().ToString("yyyy-MM-dTH:mZ")
Write-Host "Setting SAS Token for container expiring at $Expiry"
$SasToken = az storage container generate-sas `
    --name $DeployContainerName `
    --account-name $StorageAccountName `
    --https-only `
    --permissions cr `
    --expiry $Expiry `
    --account-key $Key
# use Join-Path to build the path so that this works on both Linux and Windows
$TemplatePath = Join-Path ".." "ARM"
Write-Host "Uploading templates at $TemplatePath to $DeployContainerName in $StorageAccountName"
az storage blob upload-batch `
    --destination $DeployContainerName `
    --source $TemplatePath `
    --account-name $StorageAccountName `
    --sas-token $SasToken

$mainTemplateUri = $StorageAccount.primaryEndpoints.blob + "$DeployContainerName/ARM-template.json"
$DeployTimestamp = (Get-Date).ToUniversalTime().ToString("yyyyMMdTHmZ")
# Deploy
az deployment group create `
  --name "DeployLinkedTemplate-$DeployTimestamp" `
  --resource-group $ResourceGroupName `
  --template-uri $mainTemplateUri `
  --query-string $SasToken `
  --parameters subscriptionId=$SubscriptionId `
                DataverseEnvironmentId=$DataverseEnvironmentId `
                resourceGroupName=$ResourceGroupName `
                WelcomePackageUrl=$WelcomePackageUrl `
  --verbose