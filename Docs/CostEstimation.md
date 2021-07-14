# Cost Estimation

We provide ProvisionGenie free of charge, but that doesn't mean, that you don't need to pay licensing fees. 

## Azure

You will need an Azure subscription to run the Azure Logic Apps: 

While testing, we ended with less than 0.01$ per run and in the meanwhile, Azure Logic Apps became part of the [free Azure tier](https://azure.microsoft.com/en-us/updates/five-more-free-services-available-with-an-azure-free-account/). This means that you won't need to pay for ot AT ALL. More information can be found here, where you can also [sign up for a free Azure subscription](https://azure.microsoft.com/free). You can also use the [Azure Pricing calculator](https://azure.microsoft.com/pricing/calculator/)

## Power Apps 

To use this solution, every user using this solution will need: 

* a Microsoft 365 license (for example Microsoft 365 E3, Microsoft 365 E5, Microsoft 365 Business Basic, Microsoft 365 Business Standard, Microsoft 365 Business Premium)
* a Power Apps per app plan OR Power Apps per user plan

💡 Effective October 1, 2021, both plans are now priced at 50% of the previous rate. More information can be found in [Microsoft's announcement](https://www.microsoft.com/en-us/licensing/news/pricing_and_licensing_updates_coming_to_power_apps) 

If you already have a Power Apps per user plan for all users who shall use this app, you are already set. 
If you already have a Power Apps per app plan (purchased before Ocrober 2021), you will need to look if you already exceeded the limit of 2 apps. If yes, we advise to consider upgrading to a Power Apps per user plan as of October 2021, as this unlocks not only this app but unlimited apps. 

We make use of Dataverse, which is the only reason why a Power Apps license is required. Please read our [Considerations about where we store data](Considerations-on-Dataverse.md) to understand why working around the licensing fee for Power Apps by using for example SharePont or Dataverse for Teams is not a good idea. 





