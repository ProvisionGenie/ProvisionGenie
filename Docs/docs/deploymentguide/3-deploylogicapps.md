# 3. Deploy Logic Apps

The scripted deployment will create two resource groups, by default these are `ProvisionGenie` and `ProvisionGenie-deploy`.

In the `ProvisionGenie-deploy` the script will create a new storage account, with the name that is supplied. A SAS Token with create and read permissions is created and used to upload the ARM template files into a container within the storage account. Then the ARM template deployment is started.

## Deploy using the script

- Copy the script listed [here](../scripts/Deploy-Solution.ps1)
- Open Azure cloud shell at [shell.azure.com](https://shell.azure.com)
- Open VSCode `code .`
- Paste the contents of the script and save the file as `Deploy-Solution.ps1`
- Execute the script `.\Deploy-Solution.ps1`
- In the following script, change the

  - $originResourceGroupName value to `ProvisionGenie-deploy`
  - $storageAccountName value to your storage account name
  - $location value to your preferred location - in case you don't know the name (not: Displayname), you may obtain a list using Azure cloud shell with `az account list-locations`
  - $QueryString value to the SAS token you just copied

- Execute the script in Azure cloud shell at [shell.azure.com](https://shell.azure.com)
- the script will run and prompt you to provide some parameters, they should now all be saved in here: [copied values](copiedvalues.md)

  - your Subscription ID
  - the Environment ID (you obtained it as **Instance URL**)
  - the URL for learning material (if you don't know that for now, you can put `https://m365princess.com` or any other URL into it)
  - the App ID from your Azure AD app registration
  - the App secret from your Azure AD app registration
  - the Tenant ID from you Azure AD app registration

```powershell
# Set values
$originResourceGroupName="<your resource group name here>"
$storageAccountName="<your storage account name here>"
$containerName = "templates"
$location = "<your location here>"
$sasToken = "<your SAS token here>"

# Create a key
$key = (Get-AzStorageAccountKey -ResourceGroupName $originResourceGroupName -Name $storageAccountName).Value[0]
$context = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $key

$mainTemplateUri = $context.BlobEndPoint + "$containerName/ARM-template.json"
$targetResourceGroupName="ProvisionGenie"

# Deploy
New-AzResourceGroupDeployment `
  -Name DeployLinkedTemplate `
  -ResourceGroupName $targetResourceGroupName `
  -TemplateUri $mainTemplateUri `
  -QueryString $sasToken `
  -verbose
```
