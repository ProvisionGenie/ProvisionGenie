# 1. Register application in Azure AD

To access the Dataverse tables that you will import in step 2, you will first need to register an application an Azure AD.

- Open Azure cloud shell at [shell.azure.com](https://shell.azure.com)
> This guide assumes the use of a PowerShell environment.
- Clone the git repository to Azure Cloud Shell `git clone https://github.com/ProvisionGenie/ProvisionGenie.git`
- Change the working directory to the `ProvisionGenie/Deployment/Scripts` folder
    - `cd ./ProvisionGenie/Deployment/Scripts`
- Run the script `./Create-AadAppRegistration.ps1`
> Note that this will create the AAD App Registration in the  AAD tenant for current subscription with the name `ProvisionGenieApp`. If you wish to target another subscription or provide a custom name then optional parameters are available `./Create-AadAppRegistration.ps1 -SubscriptionId "00000000-0000-0000-0000-000000000000" -AadAppName MyCustomAadAppName`

Also you will need the URL of your Microsoft 365 tenant. You can obtain this value like this:

- Open [https://office.com](https://office.com)
- Sign into the tenant you want to deploy ProvisionGenie in
- Select the **SharePoint** icon
- From the URL that should look like this `https://<your-tenant-name-here>.sharepoint.com/_layouts/15/sharepoint.aspx?` take this part: `https://<your-tenant-name-here>.sharepoint.com` and save it somewhere, you will need it later.

Next step is to obtain your Azure tenant id from  the [Azure portal](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Properties) - save it somewhere, you will need it later.
