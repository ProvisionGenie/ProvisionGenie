# ProvisionGenie

![Genie Header image](media/index/Genie_Header.png)

ProvisionGenie is an app for [Microsoft Teams](https://www.microsoft.com/microsoft-teams/group-chat-software) that lets you learn how your team can work best in Microsoft Teams. As Teams is a platform that can connect to a lot of services, we want to make your start even easier. We will

- skill you up and
- guide you through some questions regarding how your Team should look like and
- let you request the 'Team of your dreams' as a result of that process, which will be provisioned automatically for you.

![Walkthrough](media/index/walkthrough.gif)

## Core components of this solution

- [Power Apps Canvas App](corecomponents/canvasapp.md) which serves as our UI
- [8 Dataverse tables](corecomponents/logicapps.md#solution-overview) where we log all Teams requests
- [8 Azure Logic Apps flows](corecomponents/logicapps.md) which we use to provision the requested Teams
- [Language Packs](corecomponents/languagepacks.md) to support 11 languages

## How to get started

- Read our [Fact sheet for Admins](adminfactsheet.md) to understand the impact of ProvisionGenie
- Familiarize yourself with the [Solution overview](corecomponents/logicapps.md#solution-overview)
- Understand our [Architecture Decisions](architecturedecisions.md)
- Use our [Deployment Guide](deploymentguide) to deploy ProvisionGenie

## What does it cost?

- ProvisionGenie is an open-source project and we won't charge you for using, extending, or modifying it. For more information see our [license](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/LICENSE.md)
- To make the app work, you will need all of the following:
  - an [Azure subscription](https://azure.microsoft.com/) -for more detail see [Cost estimation](costestimation.md)
  - a [Power Apps per app](https://powerapps.microsoft.com/pricing/) or a [Power Apps per user](https://powerapps.microsoft.com/pricing/) plan as we use [Microsoft Dataverse](https://powerplatform.microsoft.com/dataverse/) to store data
  - a [Microsoft 365 license](https://www.microsoft.com/microsoft-365/business/compare-all-microsoft-365-business-products) for every user who uses the app.

## Roadmap

This is already Version 3.0.0. - we love the continuous work on it. For more info in versioning, head over to [Release Notes](about/releasenotes.md).

You can also have a look into our [Roadmap](about/roadmap.md) to see what's coming in the future.

## Contributions

We welcome contributions, we summarized how you can contribute in the [Contribution guidelines](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/CONTRIBUTING.md). Feel free to contribute to ProvisionGenie and make it even better. Every contribution counts and everyone's voice matters. You can help us

- improve UI/UX
- fix documentation
- find (and fix) bugs
- extend use cases
- provide translations

If you want to know more how that works, we created a [Contribution Guide](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/CONTRIBUTING.md) and also [Issue](https://github.com/ProvisionGenie/ProvisionGenie/issues/new/choose) templates to make it easy for you.

We also listed [some features that we would like to add in the future](https://github.com/ProvisionGenie/ProvisionGenie/issues)- but consciously decided to not build for our first release, as we wanted to ship rather sooner than later - to get your valuable feedback. Speaking of which: Please do [submit your feedback](https://github.com/ProvisionGenie/ProvisionGenie/issues/new?assignees=&labels=&template=feedback.md&title=), or just get in touch with us for a chat!

## Support us

💖 If you like this project, give it a ⭐ and share it with your friends 🙏!

Also, buy us coffee ☕☕☕ - ProvisionGenie wouldn't be possible without it!

[!["Buy Us A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/mG3ghJC)

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/legal/intellectualproperty/trademarks). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.

## Disclaimer

THIS CODE IS PROVIDED AS IS WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.

[![Visitors](https://api.visitorbadge.io/api/combined?path=https%3A%2F%2Fgithub.com%2Fprovisiongenie%2Fprovisiongenie&label=Genie-Fans&countColor=%236264a7&style=flat-square)](https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2Fprovisiongenie%2Fprovisiongenie) <a href="https://gitmoji.dev">
<img src="https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg?style=flat-square" alt="Gitmoji">
</a>
