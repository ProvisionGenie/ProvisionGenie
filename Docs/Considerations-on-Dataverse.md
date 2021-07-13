# Considerations on where to store data - or why we do it in Dataverse

🚨 still under construction 🚨
ProvisionGenie uses Dataverse to store all data about the provisioned teams in 5 different tables (for more information on this, see [Solution Overview](SolutionOverview.md)) As this is the only reason why we need a Power Apps per app plan or a Power Apps per user Plan, here are some thoughts on why why chose Dataverse over

* SharePoint
* Dataverse for Teams


## Dataverse vs. SharePoint

as much as we love SharePoint for content & collaboration within Microsoft 365, it is not an appropriate service to store data like we intend it with ProvisionGenie:

### Security

### Performance

### Issues

## Dataverse vs. Dataverse for Teams

* technical debt/lifecycle of Teams

