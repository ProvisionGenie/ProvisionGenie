# Admin Fact Sheet

🚨 still under construction
![Genie Header](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/media/Genie_Header.png)

This Fact sheet shall give administrator an overview about the added value for users, implications on costs, security, privacy and governance and what it takes to deploy & maintain the solution. 

## Cost to run ProvisionGenie

ProvisionGenie itself is free, but you will need 

* an Azure subscription  to run the Logic Apps. Logic Apps are part of the free tier for up to 4000 actions. 
* a Microsoft 365 license for every user who uses the app
* a Power Apps per app or Power Apps per user plan for every user who uses the app

For more detail, please head over to [Cost estimation](CostEstimation.md)

## Security/Privacy/Governance concerns

We take security, privacy, and governance very serious and want you to make an informed decision, that you can consider ProvisionGenie to be a good fit for your organization: 

### Security

* You can't unintentionally overexpose data just by allowing Power Apps in your organization as Power Apps does not provide users with access to any data assets that they don't already have access to
* Power Platform leverages Azure Active Directory to control user authentication & access to data
* In the Dataverse environment, access is controlled at three levels: 
  * Environment roles
  * Resource permissions for Power Apps
  * Dataverse security roles
* Conditional Access Policy via Azure AD Premium can be applied for Power Apps as well
* Data loss prevention policies can prevent data leakage  
  
### Privacy

More helpful resources:
* [trust.microsoft.com](https://www.microsoft.com/trust-center)
* [Microsoft Privacy statement](https://privacy.microsoft.com/en-us/privacystatement?culture=en-us&country=US)
* [In detail report on Dynamics 365 and Power Platform:Availability, data location, language, and localization - PDF download](https://aka.ms/dynamics_365_international_availability_deck)
* [Detailed information on geographical availability - Power BI report](https://dynamics.microsoft.com/Report/GetGeoReport/)

### Governance

* ProvisionGenie can be monitored like every other Power platform solution within the [Center of Excellence Starter Kit](https://docs.microsoft.com/en-us/power-platform/guidance/coe/starter-kit), which we highly recommend to use

## End User value of ProvisionGenie

Purpose of this app is to foster teamwork by letting owners-to-be of Microsoft Teams teams make smarter decisions on how a team can work in Teams. Usually, a business consultant would talk a team through assets that are available in Teams and Microsoft 365 and answer all questions with 'it depends'. They would explain that people usually

* confuse chat with task assignments "could you please"
* confuse email with status reports "per my last email"
* confuse SharePoint with a dumpster for any file in the world --> "can you migrate this pile of mess to someone else's computer?"

The consultant would then show them what channels are made for, how a team can work with metadata on files and how stying on track works with Microsoft Lists. The consultant would ask them also if they wanted more learning material pinned to their brand new team and if they wanted the team of they dreams already be created for them, so that it works from Day 1. 

This is, what Provisiongenie does. ProvisionGenie is now that consultant and provides users with a blended experience of 

* learning about modern collaboration and assets that can be used in Teams and 
* reflecting on how they want to work in Teams. 

Benefits: 

* allows better understanding of how Teams works in general
* Tailor-fitted teams have higher adoption rates
* Mitigates Teams sprawl by preventing abandoned Teams
* Prevents "stockpiled" channels (and their SharePoint folder equivalents)
* Enables better adoption of the correct usage of SharePoint lists & libraries

For more information head over to [Canvas App Overview](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/Docs/CanvasAppOverview.md#high-level-overview-on-what-the-canvas-app-does)

## Overall complexity to deploy and maintain ProvisionGenie

To get a better understanding of ProvisionGenie we highly recommend to familiarize yourself first with our [Solution overview](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/Docs/LogicApps.md#solution-overview). Additionally we provide you with a pictured step by step [Deployment Guide](DeploymentGuide.md) that walks you through the entire deployment. If something doesn't work you can always [raise an issue](https://github.com/ProvisionGenie/ProvisionGenie/issues/new/choose) and we will help. We don't believe that you will experience major difficulties, as we of course tested the deployment before. 

## Update schedule 

This is an open-source project and we welcome [contributions](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/CONTRIBUTINGt.md). 

We will version like this:

* We will merge PRs about fixing defects or optimizing existing code fortnightly and release a patch which you can then use
* New features without breaking changes will be released in minor versions
* breaking changes will be released only in major versions

You can familiarize yourself with our [Roadmap](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/Docs/Roadmap.md) to know what's coming when. 

