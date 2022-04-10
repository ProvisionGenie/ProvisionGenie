# Power Apps Canvas App

![header image](../media/index/Genie_Header.png)

Purpose of ProvisionGenie is to foster teamwork by letting owners-to-be of Microsoft Teams teams make smarter decisions on how a team can work in Teams. Usually, a business consultant would talk a team through assets that are available in Teams and Microsoft 365 and answer all question with 'it depends'. They would explain that people usually

- confuse chat with task assignment "could you please"
- confuse email with status reports "per my last email"
- confuse SharePoint with a dumpster for any file in the world "can you migrate this pile of mess to someone else's computer?"

and show them what channels are made for, how a team can work with metadata on files and how staying on track works with Microsoft Lists. The Business consultant would ask them if they wanted more learning material pinned to their brand new team and if they wanted the team of they dreams already be created for them, so that it works from Day 1.

This is, what ProvisionGenie does:

## High level overview on what the Canvas App does

- Short upskilling nuggets in Pop Ups so that owner can make informed decisions on channels, metadata and tools to use
- Questionnaire to get information on
    - Teams Name, Teams Description and logged in user to provision the Team itself
    - Channels
    - Name of SharePoint list & columns
    - Name of SharePoint library & columns
    - if Owner additionally wants a SharePoint list for task management (see also why we don't provision Planner in ProvisionGenie in our [Architecture Decisions](../architecturedecisions.md#no-microsoft-planner-provisioning))
    - if Owner additionally wants the "Welcome package"
    - if Owner additionally wants the Notebook of the SharePoint site that backs the Team pinned to the channel **General** as a tab
- Patch 6 Dataverse tables with the information we got by user

As a result of the provisioning process, we have

- 1 Teams team (with a corresponding SharePoint team site that includes the default document library [but without the Teams Wiki](../architecturedecisions.md#teams-wiki).
- as many channels as requested
- 1 additional library with as many as requested columns of type
    - single line of text
    - multiple lines of text
    - number
    - date
    - date and time
    - person
    - choice (with as many choices as requested)
- 1 SharePoint list with as many as requested columns of type
    - single line of text
    - multiple lines of text
    - number
    - date
    - date and time
    - person
    - choice (with as many choices as requested)
- optional: Welcome package
  - contains a link to additional learning resources pinned to channel `General` - URL can be defined during deployment process
- optional: additional SharePoint list for task management containing columns
    - Title (single line of text)
    - Description (multiple lines of text)
    - start date (date)
    - due date (date)
    - assigned person (person)
    - priority (choice [urgent, high, medium, low])
- optional: Notebook tab in channel **General**

For more context on how this canvas app fits into our solution, please head over to [Solution Overview](logicapps.md#solution-overview) and [Architecture Decisions](../architecturedecisions.md)

## How do I get the app?

- To get the entire solution as-is, head over to our [Deployment Guide](../deploymentguide/0-forkclone.md)
- To contribute to it, please see our [Contribution Guide](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/CONTRIBUTING.md)
- If you like to reverse-engineer it, please see our [How to build the canvas app](howtobuildthecanvasapp.md) guide as a start.
- You can also download the `.zip` file from here and import the solution into your environment - please note that this won't give you the full experience, as the entire process of provisioning does not run in this canvas app but in Azure Logic Apps flows which get triggered by new rows in different tables in Dataverse.

## What if something doesn't work?

Please [report bugs as issues](https://github.com/ProvisionGenie/ProvisionGenie/issues/new?assignees=&labels=&template=bug_report.md&title=), so we can work on them! You are also invited to contribute to the app - let's make ProvisionGenie together even better!
