# Deployment Guide

## Prerequisites

* Azure Subscription
* M 365 license
* Power Apps per app or Power Apps per user plan
* Environment with Dataverse database
<!-- don't rightclick publish to production :-)  -->
* Admin role

## Steps

1. App registration for Dataverse
2. managed identity
  * PS script
3. import the solution: Dataverse tables & Canvas App
4. Deploy Azure Logic Apps
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
