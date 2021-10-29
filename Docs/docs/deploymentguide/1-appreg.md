# 1. App registration to access Dataverse tables

You will need to register an app in Azure AD in order to access the dataverse tables in the Logic Apps.

- Go to [portal.azure.com](https://portal.azure.com)
- Log in
- Select **Azure Active Directory**

![Azure Portal](../media/deploymentguide/1-appreg/AzurePortal.png)

- (1) Select **App registrations**
- (2) Select **New registration**

![App registrations](../media/deploymentguide/1-appreg/AzurePortalADAppregistrationsSteps.png)

- (1) Type in a name for your app like `ProvisionGenieApp`
- (2) Select **Accounts in this organizational directory only (<your organization name> only - Single tenant)**
- (3) Select **Register**

![Register new app](../media/deploymentguide/1-appreg/AzurePortalADAppregistrationsNew.png)

- (1) Select **API permissions**
- (2) Select **Add a permission**
- (3) Select **Dynamics CRM**

![Add permissions](../media/deploymentguide/1-appreg/AzurePortalADAppregistrationsAddPermissionSteps.png)

- (1) Select **user_impersonation**
- (2) Select **Add permissions**

![User Impersonation](../media/deploymentguide/1-appreg/AzurePortalADAppregistrationsAddPermissionDynCRMUserImpersonationSteps-cut.png)

- (1) Grant admin consent
- (2) Confirm with **Yes**

![Grant Admin Consent](../media/deploymentguide/1-appreg/AzureAdGrantAdminConsent.png)

Let's now create a secret:

- (1) Select **Certificates & secrets**
- (2) Select **New client secret**
- (3) Enter a description like `PG-secret`
- (4) Select a value when this secret expires
- (5) Select **Add**

![Certificates & secrets](../media/deploymentguide/1-appreg/AzurePortalADAppregistrationssecretSteps.png)

- Copy the secret's **Value** and save it somewhere, you can do this here: [copied values](copiedvalues.md) -This way you have everything handy when you need it. We will ask you during this deployment process to save a couple of values. Please take care that you don't commit this file in case you want to contribute to ProvisionGenie.

![Copy secret's value](../media/deploymentguide/1-appreg/AzurePortalADAppregistrationsNewSecretCopyValue.png)

- (1) Select **Overview**
- (2) Copy the **Application (client)ID** value, save it here: [copied values](copiedvalues.md)
- (3) Copy the **Directory (tenant)ID** value, save it here: [copied values](copiedvalues.md)

![Copy values](../media/deploymentguide/1-appreg/AzurePortalADAppregistrationscopyvalues.png)

That's it!