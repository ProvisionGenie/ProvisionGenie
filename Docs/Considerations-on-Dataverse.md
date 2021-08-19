# Considerations on where to store data - or why we do it in Dataverse

![header image](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/Docs/media/Genie_Header.png)

ProvisionGenie uses Dataverse to store all data about the provisioned teams in 5 different tables (for more information on this, see [Solution Overview](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/Docs/LogicApps.md#solution-overview)). As this is the only reason why we need a Power Apps per app plan or a Power Apps per user Plan, here are some thoughts on why we chose Dataverse over

- SharePoint
- Dataverse for Teams

## Dataverse vs. SharePoint lists

As much as we love SharePoint for content & collaboration within Microsoft 365, it is not an appropriate service to store data like we intend it with ProvisionGenie:

### Issues with Developer Experience

- Delegation: In Canvas Apps, heavy processing of data is delegated to the data connection. Common formulas in Power Apps are not delegatable to SharePoint: This means that it's difficult to return more than 500 (default) to 2000 (max) records at a time in SharePoint. Although this is not our core use case in ProvisionGenie, we want the entire solution to be future-proof
- Filter for data from SharePoint lists have some hard to overcome limits, like yes/no fields are not filterable
- All SharePoint lists are independent from each other. And although lists can have lookup columns that could refer to other lists, a SharePoint list is by no means a relational database. Lookup columns are not only causing a challenging developer experience but also lead to massive performance issues

### Performance issues

The (non-premium) SharePoint connector pipelines to SharePoint lists and we experience the following issues:

- A SharePoint list that contains many columns leads to slowness
- Too many dynamic lookup columns: especially lookup, person or calculated columns eat performance
- Huge lists cause extra overhead

> Rule of thumbs: The more items, columns and lookup columns your lists needs to contain, the more likely your user experience will be poor

### Security issues

A Power Apps Canvas app that writes data into a SharePoint list comes with some extra security issues. Our main concern is, that every user who wants to use the app needs to have permissions for this list. This means, that they could manipulate data in the list bypassing the app. Of course you could try to hide the list on the respecting SharePoint site, but that would just be obscurity, not security.

## Dataverse vs. Dataverse for Teams

We also took Dataverse's little sister, [Dataverse for Teams](https://docs.microsoft.com/powerapps/teams/data-platform-compare) into consideration but needed to it turn down, because we don't want security roles, [lifecycle](https://docs.microsoft.com/power-platform/admin/about-teams-environment#environment-lifecycle) and governance of our solution (and its environment) to be tied to a team in which [every user needs to be a member of](https://docs.microsoft.com/powerapps/teams/data-platform-compare) to use ProvisionGenie.
