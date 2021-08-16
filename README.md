# ProvisionGenie

![Genie Header image](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/media/Communication/Genie_Header.png)

ProvisionGenie is an app for [Microsoft Teams](https://www.microsoft.com/microsoft-teams/group-chat-software) that lets you learn how your team can work best in Microsoft Teams. As Teams is a platform that can connect to a lot of services, we want to make your start even easier. We will

* skill you up and
* guide you through some questions regarding how your team should look like.

👉As a result, you can request the 'Team of your dreams', which will be provisioned automatically 🦄 for you.

![Walkthrough](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/media/canvasapp/walkthroughgif.gif)

## Core components of this solution

* [Power Apps Canvas App](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/Docs/CanvasAppOverview.md) which serves as our UI
* [5 DataVerse tables](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/Docs/LogicApps.md#solution-overview) where we log all Teams requests
* [5 Azure Logic Apps flows](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/Docs/LogicApps.md) which we use to provision the requested Teams

## How to get started

* Read our to understand the impact of ProvisionGenie [Fact sheet for Admins](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/Docs/Admin-fact-sheet.md)
* Familiarize yourself with the [Solution overview](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/Docs/LogicApps.md#solution-overview)
* Use our [Deployment Guide](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/Docs/DeploymentGuide.md) to deploy ProvisionGenie
* Understand the [License](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/LICENSE.md)

## What does it cost?

* ProvisionGenie is an open-source project and we won't charge you for using, extending, or modifying it. For more information, please see our [license](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/LICENSE.md)
* To make the app work, you will need
  * an [Azure subscription](https://azure.microsoft.com/) -for more detail see [Cost estimation](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/Docs/CostEstimation.md)
  * a [Power Apps per app](https://powerapps.microsoft.com/pricing/) or a [Power Apps per user](https://powerapps.microsoft.com/pricing/) plan as we use [Microsoft Dataverse](https://powerplatform.microsoft.com/dataverse/) to store data
  * a [Microsoft 365 license](https://www.microsoft.com/microsoft-365/business/compare-all-microsoft-365-business-products) for every user who uses the app

## Version/Roadmap

This is our very first Version 1.0.0. For more info, please head over to [Release Notes](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/Docs/Release-Notes.md). Please note, that this is our minimal l♥vable product - feel free to contribute and make it better. Every contribution counts and everyone's voice matters. You can help us

* improve UI/UX
* fix documentation
* find (and fix) bugs
* extend use cases and more

If you want to know more how that works, we created a [Contribution Guide](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/CONTRIBUTING.md) and also [Issue](https://github.com/ProvisionGenie/ProvisionGenie/issues/new/choose) templates to make it easy for you.

We also listed [some features that we would like to add in the future](https://github.com/ProvisionGenie/ProvisionGenie/issues)- but consciously decided to not release in V1.0 as we wanted to release rather sooner than later - to get feedback. Speaking of which: Please do [submit your feedback](https://github.com/ProvisionGenie/ProvisionGenie/issues/new?assignees=&labels=&template=feedback.md&title=), or just get in touch with us for a chat!

You can have a look into our [Roadmap](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/docs/Roadmap.md) to see what's coming in the future.

## Developers

<img width="400" alt="Carmen and Luise" src="https://github.com/ProvisionGenie/ProvisionGenie/blob/main/media/Communication/Carmen_Luise.png">

This solution is an initiative by [Luise Freese](https://m365princess.com) and [Carmen Ysewijn](https://digipersonal.com/).

## Contributions

We welcome contributions, we summarized how you can contribute in the [contribution guidelines](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/CONTRIBUTING.md).

## Support us

💖 If you like this project, give it a ⭐ and share it with your friends!

Also, buy us coffee - ProvisionGenie wouldn't be possible without it!

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/mG3ghJC)

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/legal/intellectualproperty/trademarks). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.

## Disclaimer

THIS CODE IS PROVIDED AS IS WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
