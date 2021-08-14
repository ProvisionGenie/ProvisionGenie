# Known Limitations

✍ still under construction

![header image](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/media/Genie_Header.png)

Additionally to features to add (see [Issues](https://github.com/ProvisionGenie/ProvisionGenie/issues)), there are some limitations to this solution, which aren't bugs 🐞.

## No Planner integration in ProvisionGenie

We use [Microsoft Graph API](https://docs.microsoft.com/graph/overview) to provision all assets that were requested by users using the Power Apps Canvas app with Azure Logic Apps. As the Planner API lacks of having application level permissions, we decided to not use it, as it would cause a lot of disadvantages like

* need of a service account
* which couldn't be MFA-enabled

This is why we chose to ask our user if they wanted to have a SharePoint list with columns that mimics Planner behavior provisioned for them. We introduce users as well to gallery view in lists so that they get a similar experience as in Planner. As we can create SharePoint lists and their columns with application permissions, this felt as a secure alternative.
