# Deployment Guide

![header image](../media/index/Genie_Header.png)

This guide shall walk you through the minimal path to awesome. It lists all steps required to successfully deploy ProvisionGenie in your tenant. If you haven't done this by now, familiarize yourself with our [solution overview](/Docs/LogicApps.md#solution-overview).

## Prerequisites

- Azure Subscription -if you don't have one, [get it here free](https://azure.microsoft.com//free) - also see [Cost estimation](../costestimation.md)
- Microsoft 365 license
- [Power Apps per app or Power Apps per user plan](https://powerapps.microsoft.com/pricing/) (for using Dataverse, also see [Architecture Decisions](../architecturedecisions.md#database)). You can also go with a [Pay-as-you-go-plan](https://docs.microsoft.com/en-us/power-platform/admin/pay-as-you-go-overview)
- Environment with [Dataverse database](https://docs.microsoft.com/power-platform/admin/create-database) - you can create one during the deployment process
- Admin role Azure: [Contributor](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#contributor)
- Power Platform role: [System Administrator](https://docs.microsoft.com/power-platform/admin/database-security)

## Deployment steps clean install

In order to successfully deploy ProvisionGenie from as a first deploy, you will need to perform the following steps

- [0. Fork and clone this repository](0-forkclone.md)
- [1. Register app in Azure AD](1-registerapp.md)
- [2. Import Dataverse solution](2-importsolution.md)
- [3. Deploy Azure resources](3-deployazureresources.md)
- [4. Add ProvisionGenie to Teams](4-addtoteams.md)
- [5. Post Deployment cleanup](5-postdeploycleanup.md)
