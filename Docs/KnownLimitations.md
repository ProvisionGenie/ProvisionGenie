# Known Limitations

✍ still under construction

![header image](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/media/Genie_Header.png)

Additionally to features to add (see [Issues](https://github.com/ProvisionGenie/ProvisionGenie/issues)), there are some limitations to this solution, which aren't bugs 🐞.

## No Planner integration in ProvisionGenie

We use [Microsoft Graph API](https://docs.microsoft.com/graph/overview) to provision all assets that were requested by users using the Power Apps Canvas app with Azure Logic Apps. As the Planner API lacks of having application level permissions, we decided to not use it, as it would cause a lot of disadvantages like

* need of a service account
* which couldn't be MFA-enabled

This is why we chose to ask our user if they wanted to have a SharePoint list with columns that mimics Planner behavior provisioned for them. We introduce users as well to gallery view in lists so that they get a similar experience as in Planner. As we can create SharePoint lists and their columns with application permissions, this felt as a secure alternative.

![task list in SharePoint](Docs/media/tasklist.png)

## No Wiki

As part of our provisioning process, we delete the Teams Wiki from all created channels. We believe, that the Wiki is not a good place to store any kind of knowledge in.

The Wiki is a (hidden) SharePoint library called `Teams Wiki Data` in the team site that backs the Team. You can find it here: `https://<your-tenant-here>.sharepoint.com/sites/<your-team-site-here>/Teams%20Wiki%20Data`. When a user removes Wiki tab from a channel, all content in that hidden library gets hard-deleted without any chance to be restored. There are even more reasons to not like the Wiki:

* Wiki is not searchable
* Wiki doesn't allow co-authoring
* Wikis can't be moved

Of course our decision to delete the Wikis from all initial channels does not prevent users from adding a Wiki tab to an existing or manually created channel, but at least it is not the default behavior in a new Team. In the future, we want to automatically add a OneNote notebook.
