## App registration to access Dataverse tables using Azure CLI

- Open [shell.azure.com](https://portal.azure.com/#cloudshell/)
- to register the application run

```Azure CLI
az ad app create --display-name 78ce3f0f-a1ce-49c2-8cde-64b5c0896db4 --available-to-other-tenants false
#save the appId
$adappid =(az ad app list --display-name Luise3 --query [0].appId --out tsv --all)
# create an app secret, run
az ad app credential reset --id $adappId --append
```

In the output, you will get four values for

- **AppId**,
- **name** (equals **AppId**),
- **password** (this is your App secret) and
- **tenant** (this is your TenantID).

```azurecli

#Set API permissions for user impersonation in Dynamics CRM
az ad app permission add --id $adappid --api 00000007-0000-0000-c000-000000000000 --api-permissions 78ce3f0f-a1ce-49c2-8cde-64b5c0896db4=Scope
```

Note, that `00000007-0000-0000-c000-000000000000` is Dynamics CRM and `78ce3f0f-a1ce-49c2-8cde-64b5c0896db4=Scope` is **user_impersonation** which we need to act on behalf of a user.

- now grant admin consent by running

```azurecli
az ad app permission grant --id $adappid --api 00000007-0000-0000-c000-000000000000
```

That's it!

## New resource group with Azure CLI

- open [shell.azure.com](https://portal.azure.com/#cloudshell/)
- run

```Azure CLI
az group create -n <ProvisionGenie> --location <your-location-here>
```

now create the second resource group

```Azure CLI
az group create -n <ProvisionGenie-deploy> --location <your-location-here>
```

Create a storage account

```Azure CLI
az storage account create -n pgstorage -g provisionGenie-deploy -l westeurope --sku Standard_LRS
```

Create container

```Azure CLI
az storage container create -n pg-deploy --account-name pgstorage--auth-mode login
```

## Deploying with Azure CLI and PowerShell

This guide has been tested with:

- PowerShell 7.1.4
- Azure CLI 2.28.0

Before running this script you should have signed into the cli and set the target subscription if you have more than one subscription associated with your account.

- [Sign in with Azure CLI](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli)
- [Change the active subscription](https://docs.microsoft.com/en-us/cli/azure/manage-azure-subscriptions-azure-cli)

This script assumes that it is being run from inside the `Deployment/Scripts` folder.  

```PowerShell
./Deploy-Solution.ps1 -Location -StorageAccountName -DataverseEnvironmentId [-ResourceGroupName] [-SubscriptionId] [-WelcomePackageUrl]
```

### Example Usages

```PowerShell
Deploy-Solution.ps1`
```

> User will be prompted for all required parameters

```PowerShell
./Deploy-Solution.ps1 -Location westus2 -StorageAccountName pgdeploy -DataverseEnvironmentId https://org1234456.crm4.dynamics.com`
```

> System will use defaults for all optional parameters

```PowerShell
./Deploy-Solution.ps1 -Location westus2 -StorageAccountName pgdeploy -DataverseEnvironmentId https://org1234456.crm4.dynamics.com -ResourceGroupName MyResourceGroup -SubscriptionId 00000000-0000-0000-0000-000000000000 -WelcomePackageUrl https://google.com
```

> User supplies all parameters an no defaults are used

### Required Parameters

`-Location`

The Azure region that the resources are to be deployed in.

`-StorageAccountName`

The name of the storage account used to hold the ARM templates for deploying ProvisionGenie. This must be globally unique.

`-DataverseEnvironmentId`

The Id of the Dataverse environment hosting the database tables

`WelcomePackageUrl`

The url of the welcome package to be used e.g. `https://m365princess.com`

### Optional Parameters

`-ResourceGroupName`
> Default value: ProvisionGenie

The name of the Resource Group to be created to contain the ProvisionGenie LogicApps. A second Resource Group named `<ResourceGroupName>-deploy` is also created to host the ARM templates required to deploy the ProvisionGenie solution.

`SubscriptionId`
> Default value: The current default subscription for the Azure CLI environment

The Id of the Azure Subscription to deploy into.

`-AadAppName`
> Default value: ProvisionGenieApp

The name of the AAD App Registration to be created to authenticate against Dataverse.
