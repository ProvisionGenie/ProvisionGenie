# Deployment Guide


This Guide shall guide you through the minmal path to awesome. It lists all steps required to successfully deploy ProvisionGenie in your tenant. 

🚨 still under construction

## Prerequisites

* Azure Subscription
* Microsoft 365 license
* Power Apps per app or Power Apps per user plan (for using Dataverse, please also see [Considerations about where to store data]()) 
* Environment with Dataverse database

> Please do this with your best knowledge about an environment strategy, please dont *rightclick --> publish

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
* select **Grant admin consent for \<name of your organization>**
* confirm by selecting **Yes**
* Select **Certificates & secrets**
* Select **New client secret**
* Enter a description
* Select a value when this secret expires
* Select **Add** 
* Copy the secret's **Value** and save it somewhere
* Select **Overview** and copy the **Application (client) ID** value, save it somewhere
* copy the **Directory (tenant) ID** value, save it somewhere

### 2. Managed identity
  * PS script

### 3. Deploy Logic Apps
<!-- 4. import the solution: Dataverse tables & Canvas App
5. Deploy Azure Logic Apps
  * fill in variables
4. 
5. test -->
### 4. Import solution: Dataverse tables & Canvas App

### braindump

<!-- 
1. create a resource group either in UI or with CLI
2. app registration
3. deploy 
    * commondataservice hard coded/displayname
    * authenticate
    * https://vincentlauzon.com/2018/09/25/service-principal-for-logic-app-connector/ service principal
 -->
