# Deployment Guide

🚨 still under construction 💡

![header image](media/Genie_Header.png)

This guide shall walk you through the minimal path to awesome. It lists all steps required to successfully deploy ProvisionGenie in your tenant. If you haven't done this by now, familiarize yourself with our [solution overview](/Docs/LogicApps.md#solution-overview)

## Prerequisites

- Azure Subscription - if you don't have one, [get it here free](https://azure.microsoft.com//free) - also see [Cost estimation](CostEstimation.md)
- Microsoft 365 license
- [Power Apps per app or Power Apps per user plan](https://powerapps.microsoft.com/pricing/) (for using Dataverse, also see [Architecture Decisions](/Docs/ArchitectureDecisions.md#database)
- Environment with [Dataverse database](https://docs.microsoft.com/power-platform/admin/create-database) - you can create one during the deployment process
- Admin role Azure: [Contributor](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#contributor)
- Power Platform role: [System Administrator](https://docs.microsoft.com/power-platform/admin/database-security)

## Deployment steps

In order to successfully deploy ProvisionGenie, you will need to perform the following steps

- [0. Fork and clone this repository](DeploymentGuide.md#0-Fork-and-clone-this-repository)
- [1. App registration to access Dataverse tables](DeploymentGuide.md#1-App-registration-to-access-Dataverse-tables)
- [2. Dataverse solution](DeploymentGuide.md#2-dataverse-solution)
- [3. Create new Azure resource groups](DeploymentGuide.md#3-create-new-azure-resource-groups)
- [4. Deployment of Azure Logic Apps](DeploymentGuide.md#4-deployment-of-azure-logic-apps)

### 0. Fork and clone this repository

You can successfully install and run ProvisionGenie without forking and cloning the repository, but it is highly recommended, to have all necessary files available locally. Also contributing to ProvisionGenie will be easier then. If you don't know how this works, read this article about [How to get started with GitHub and Git](https://www.m365princess.com/blogs/started-github-git/).

### 1. App registration to access Dataverse tables

You will need to register an app in Azure AD in order to access the dataverse tables in the Logic Apps.

- Go to [portal.azure.com](https://portal.azure.com)
- Log in
- Select **Azure Active Directory**

![Azure Portal](media/AzurePortal.png)

- (1) Select **App registrations**
- (2) Select **New registration**

![App registrations](media/AzurePortalADAppregistrationsSteps.png)

- (1) Type in a name for your app like `ProvisionGenieApp`
- (2) Select **Accounts in this organizational directory only (<your organization name> only - Single tenant)**
- (3) Select **Register**

![Register new app](media/AzurePortalADAppregistrationsNew.png)

- (1) Select **API permissions**
- (2) Select **Add a permission**
- (3) Select **Dynamics CRM**

![Add permissions](media/AzurePortalADAppregistrationsAddPermissionSteps.png)

- (1) Select **user_impersonation**
- (2) Select **Add permissions**

![User Impersonation](media/AzurePortalADAppregistrationsAddPermissionDynCRMUserImpersonationSteps-cut.png)

- (1) Grant admin consent
- (2) Confirm with **Yes**

![Grant Admin Consent](docs/media/AzureAdGrantAdminConsent.png)

Let's now create a secret:

- (1) Select **Certificates & secrets**
- (2) Select **New client secret**
- (3) Enter a description like `PG-secret`
- (4) Select a value when this secret expires
- (5) Select **Add**

![Certificates & secrets](media/AzurePortalADAppregistrationssecretSteps.png)

- Copy the secret's **Value** and save it somewhere, you can do this here: [copied values](../Deployment/CopiedValues.md) -This way you have everything handy when you need it. Please take care that you don't commit this file in case you want to contribute to ProvisionGenie.

![Copy secret's value](media/AzurePortalADAppregistrationsNewSecretCopyValue.png)

- (1) Select **Overview**
- (2) Copy the **Application (client)ID** value, save it here: [copied values](../Deployment/CopiedValues.md)
- (3) Copy the **Directory (tenant)ID** value, save it here: [copied values](../Deployment/CopiedValues.md)

![Copy values](media/AzurePortalADAppregistrationscopyvalues.png)

That's it!

### 2. Dataverse solution

We built ProvisionGenie by using Dataverse mostly for security reasons. We do not want to give users a way to bypass the canvas app and access data they shouldn't have access to. This concern was one of our main reasons to not use SharePoint lists to log requests as you would need to share the list with every user. That means that they could create new items, manipulate and even delete data. For more information, head over to [Architecture Decisions](/Docs/ArchitectureDecisions.md#database).

In Dataverse, we can setup [security roles](https://docs.microsoft.com/power-platform/admin/database-security#assign-security-roles-to-users-in-an-environment-that-has-a-dataverse-database) to prevent this and we created two security roles `ProvisionGenie admin` and `ProvisionGenie user` as part of the solution that you will import in the next steps.

You will need to create an application user and assign the security role to it.

1. In case you don't have already an environment that you want to use for ProvisionGenie, follow these steps to [create a new environment with a database](https://docs.microsoft.com/power-platform/admin/create-environment#create-an-environment-with-a-database)

Important to know: a **Dataverse for Teams** environment is not enough - for reference read our [Architecture Decisions](/Docs/ArchitectureDecisions.md)

2. Import our solution with

- Dataverse tables to log the requests
- ProvisionGenie canvas app as the UI
- Security role `ProvisionGenie Admin`
- Security role `Provision Genie User`

from here: [ProvisionGenie Solution](/Deployment/Solution)

In case this is the first time you import a solution, follow the steps described here: [Import a Power Platform solution](https://docs.microsoft.com/powerapps/maker/data-platform/import-update-export-solutions)

It can take a little while:

![importing solution](media/PowerAppsSolutionImporting.png)

Once this step is completed, select the imported solution and check that it looks like this:

![Solution](media/PowerAppsSolution.png)

- Create an application user and the assign security role `ProvisionGenie Admin` and the role `Basic user` as part of the creation process as described here: [Create an application user](https://docs.microsoft.com/power-platform/admin/manage-application-users#create-an-application-user)

- Assign the security roles `Basic user` and `Provision Genie User` to all users that will be able to use ProvisionGenie for team creation.

  - You can assign the role to individual people using the steps explained [here](https://docs.microsoft.com/power-platform/admin/database-security#assign-security-roles-to-users-in-an-environment-that-has-a-dataverse-database)
  - Alternatively, you can bulk assign roles to people by following the next steps:

    - Go to the [Power Platform admin center](https://admin.powerplatform.microsoft.com) and select your environment (step 1 and 2 in the guide above)

  - In the Access pane, select **See all** under **Users**

  ![Users - see all](media/EnvironmentSettingsUsersSeeAll.png)

  - Select **Manage users in Dynamics 365** in the action bar at the top

  ![Manage users in Dynamics 365](media/EnvironmentUsersManageInD365.png)

  - Select the users you want to assign the security role to, and afterwards select **Manage roles** in the action bar

  ![Manage roles](media/EnvironmentUsersManageRoles.png)

  - In the list with security roles, select **Provision Genie user** and then **OK**

  ![Select roles](media/EnvironmentUsersSelectRoles.png)

4. You need to obtain the Environment ID for a later step:

- Open [make.powerapps.com](https://make.powerapps.com)
- Select the **Settings** gear
- Select **Session details**
- The value we need here is the **Instance URL** from [make.powerapps.com](https://make.powerapps.com), save it here: [copied values](../Deployment/CopiedValues.md)

![Power Apps session details](media/PAStudioSessionDetails.png)

### 3. Create a new Azure resource group

The yet-to-deploy Azure Logic Apps will need a resource group to be deployed in. We recommend creating a new resource group `ProvisionGenie`.

Additionally, you will need a second resource group `ProvisionGenie-deploy` in which you temporarily store the template files in. After successful deployment, you may delete this second resource group.

⚡ Repeat the following steps for both resource groups

- Open [portal.azure.com](https://portal.azure.com)
- (1) Select the Menu
- (2) Select **Resource groups**

![Azure Portal Resource Groups](media/AzureResourceGroup.png)

- (1) Select **Create**
- (2) Select a subscription
- (3) Enter the name of the Resource Group you wish to create: `ProvisionGenie` and for the second one `ProvisionGenie-deploy`
- (4) Select the region, save the value here: [copied values](../Deployment/CopiedValues.md)
- (5) Select **Review & create**

![Azure Portal Resource group create](media/AzureResourceGroupCreateForm.png)

- Notice the banner showing that validation passed
- Select **Create**

![Azure Portal Resource Groups](media/AzureResourceGroupCreateFinal.png)

On success, your new resource group will show up in the overview:

![Resource Group Overview](media/AzureResourceGroupOverview.png)

As a last step in this section, obtain your subscriptionID:

- Select the resource group you just created
- Copy the value of the **SubscriptionID**, save it here: [copied values](../Deployment/CopiedValues.md)

That's it!

### 4. Deployment of Azure Logic Apps

In the `ProvisionGenie-deploy` resource group, create a new storage account to store the template files

#### Create Storage account in Azure portal

- Open [portal.azure.com](https://portal.azure.com)
- Select **Resource groups**
- Select the `ProvisionGenie-deploy`
- Select **Create**
- Search for `storage account`
- Select **Storage account**
- Select **Create**
- Fill out the form as shown:
  - (1) Select your Azure subscription
  - (2) Select the `ProvisionGenie-deploy` resource group
  - (3) Type in a storage account name like `provisiongeniedeploy`
  - (4) Select your preferred region
  - (5) Select **Review + create**

![Create storage account](/Docs/media/AzurePortalCreateStorage.png)

- Review if everything looks ok - note that you see a **Validation passed** banner
- Select **Create**

This will take a moment or two, the Azure portal will notify you once this step is completed.

Copy the storage account name (`provisiongeniedeploy`), save it here: [copied values](../Deployment/CopiedValues.md)

##### Upload the deployment files into a container in the storage account

in your new Storage account,

- (1) Select **Containers**
- (2) Select **+ Container**
- (3) Type in `templates` in the form as a Name
- (4) Select **Create**

![create container](/Docs/media/AzurePortalCreateContainer.png)

Now upload the template files you can find in [ARM folder](/Deployment/ARM) into the `templates` container you just created:

- (1) Select **Upload**
- (2) Select the template files
- (3) Select **Upload**

![upload template files](Docs/media/../../media/AzurePortalUploadFiles.png)

We will now create a Shared Access Token in the Container:

- (1) Select **Shared access tokens**
- (2) Select **Generate SAS token and URL**
- (3) Copy the **Blob SAS token** value, save it here: [copied values](../Deployment/CopiedValues.md)

![shared access token](Docs/media/../../media/AzurePortalSAS.png)

![copy sas token](media/AzurePortalSASCopy.png)

##### prepare your deployment script

- In the following script, change the

  - $originResourceGroupName value to your resource group name
  - $storageAccountName value to your storage account name
  - $location value to your preferred location
  - $QueryString value to the SAS token you just copied

- Execute the script in Azure cloud shell at [shell.azure.com](https://shell.azure.com)
- the script will run and prompt you to provide some parameters, they should now all be saved in here: [copied values](../Deployment/CopiedValues.md)

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

##### Assign the correct permission scope for the ManagedIDentity

After successful deployment, head over to the [Azure portal](https://portal.azure.com). Then complete the following steps:

- Select the `ProvisionGenie` resource group
- Check the successful deployment of the resources

![Provisiongenie Resource Group](media/AzurePortalResources.png)

- Select `ProvisionGenie-ManagedIdentity`
- Copy the **ObjectID**, save it here: [copied values](../Deployment/CopiedValues.md)

![ManagedIDentity](media/AzurePortaMI.png)

- In the following script, paste this Object ID as value of $principalId and run the script in Azure cloud shell.

```Azure CLI
$principalId = '<your managed identity object ID goes here>'
$graphResourceId = $(az ad sp list --display-name "Microsoft Graph" --query [0].objectId --out tsv)
#Get appRoleIds for Team.Create, Group.ReadWrite.All, Directory.ReadWrite.All, Group.Create, Sites.Manage.All, Sites.ReadWrite.All
$graphId = az ad sp list --query "[?appDisplayName=='Microsoft Graph'].appId | [0]" --all
$appRoleIds = $(az ad sp show --id $graphId --query "appRoles[?value=='Team.Create'].id | [0]"), $(az ad sp show --id $graphId --query "appRoles[?value=='Group.ReadWrite.All'].id | [0]"), $(az ad sp show --id $graphId --query "appRoles[?value=='Directory.ReadWrite.All'].id | [0]"), $(az ad sp show --id $graphId --query "appRoles[?value=='Group.Create'].id | [0]"), $(az ad sp show --id $graphId --query "appRoles[?value=='Sites.Manage.All'].id | [0]"), $(az ad sp show --id $graphId --query "appRoles[?value=='Sites.ReadWrite.All'].id | [0]")
#Loop over all appRoleIds
foreach ($appRoleId in $appRoleIds) { $body = "{'principalId':'$principalId','resourceId':'$graphResourceId','appRoleId':'$appRoleId'}"; az rest --method post --uri https://graph.microsoft.com/v1.0/servicePrincipals/$principalId/appRoleAssignments --body $body --headers Content-Type=application/json }
```

- Check in Azure AD if permissions were set correctly:
  - Open [Azure Active Directory](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Overview)
  - Select **Enterprise Applications**
  - Select **ManagedIDentities** from the **Application type** dropdown menu

![Azure AD ManagedIDentities](media/AzureADMIpng.png)

- Select **ProvisionGenie-ManagedIdentity**
- Select **Permissions**

It should look like this:

![Azure AD ManagedIDentity permissions](media/AzureADMIPermissions.png)

If you wish, you can now delete storage account in `provisiongenie-deploy` resource group - In case you want/need to redeploy, you would need to recreate it to successfully run the deploy script.

Now make sure that you exclude [copied values](../Deployment/CopiedValues.md) from any future commits to this repository- we don't want you to accidentally leak secrets.

Congrats! 🧞 - You made it- We hope you enjoy ProvisionGenie!
