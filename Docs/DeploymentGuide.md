# Deployment Guide


🚨 still under construction
## Prerequisites

* Azure Subscription
* Microsoft 365 license
* Power Apps per app or Power Apps per user plan (for using Dataverse, please also see [Considerations about where to store data]()) 
* Environment with Dataverse database
<!-- don't rightclick publish to production :-)  -->
* Admin role

## Steps

### 1. App registration for Dataverse

* go to [portal.azure.com](https://portal.azure.com)
* log in
* select **Azure Active Directory**
* Select **App registrations**
* select **New registration**
* type in a name for your app like `ProvisionGenie` 
* select **single tenant**
* select **Register**
* select **API permissions**
* select **Add a permission**
* select **Dynamics CRM**
* select **user_impersonation**
* select **Add permissions**
* select **Grant admin consent for <name of your organization>**

 create secret 
    * copy value
    * copy app ID
    * copy tenant ID

3. Managed identity
  * PS script
4. import the solution: Dataverse tables & Canvas App
5. Deploy Azure Logic Apps
  * fill in variables

5. test


### braindump
1. create a resource group either in UI or with CLI
2. app registration
  * single tenant
  * name
  * **create**
  * API permissions
    * Dynamics CRM
    * user_impersonation
    * add permissions
    * Grand admin consent
    * create secret 
    * copy value
    * copy app ID
    * copy tenant ID
  3. deploy 
    * commondataservice hard coded/displayname
    * authenticate
    * https://vincentlauzon.com/2018/09/25/service-principal-for-logic-app-connector/ service principal
