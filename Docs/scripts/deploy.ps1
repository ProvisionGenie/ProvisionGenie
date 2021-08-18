$originResourceGroupName="<your resource group name here>"
$storageAccountName="<your storage account name here>"
$containerName = "templates"
$location = "<your location here>"

# Create a key
$key = (Get-AzStorageAccountKey -ResourceGroupName $originResourceGroupName -Name $storageAccountName).Value[0]
$context = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $key

$mainTemplateUri = $context.BlobEndPoint + "$containerName/ARM-template.json"
$targetResourceGroupName="ProvisionGenie"

New-AzResourceGroupDeployment `
  -Name DeployLinkedTemplate `
  -ResourceGroupName $targetResourceGroupName `
  -TemplateUri $mainTemplateUri `
  -QueryString  "sp=r&st=2021-07-29T15:26:23Z&se=2021-07-29T23:26:23Z&spr=https&sv=2020-08-04&sr=c&sig=JAZT2fA%2BMCxHBEcja%2FKEQpGjxuMGZFJ1JQIqTK%2BfMlk%3D" `
  -verbose


# and now in Azure CLI 

#   $originResourceGroupName="<your resource group name here>"
#   $storageAccountName="<your storage account name here>"
#   $containerName = "templates"

# # get key
#   $key = az storage account keys list -g $originResourceGroupName -n $storageAccountName --query [0].value --out tsv
#   //$context = <cmd to create new storage context> -n $storageAccountName -g $originResourceGroupName -l $location --sku Standard_LRS

# $app = (az storage account show -g $originResourceGroupName -n $storageAccountName) |ConvertFrom-Json

#   $mainTemplateUri = $context.BlobEndPoint + "$containerName/ARM-template.json"
#   $targetResourceGroupName="ProvisionGenie-test"


