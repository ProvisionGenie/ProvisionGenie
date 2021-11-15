#### App registration to access Dataverse tables using Azure CLI

- Open [shell.azure.com](https://portal.azure.com/#cloudshell/)
- to register the application run

```Azure CLI
az ad app create --display-name 78ce3f0f-a1ce-49c2-8cde-64b5c0896db4 --available-to-other-tenants false
#save the appId
$adappid =(az ad app list --display-name Luise3 --query [0].appId --out tsv --all)

# create a service principal for the app
az ad sp create --id $adappId

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

#### New resource group with Azure CLI

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

```
az storage account create -n pgstorage -g provisionGenie-deploy -l westeurope --sku Standard_LRS
```

Create container
