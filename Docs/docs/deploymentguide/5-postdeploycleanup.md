# Post Deployment cleanup

Make sure that you exclude [copied values](copiedvalues.md) from any future commits to this repository- we don't want you to accidentally leak secrets.

If you wish, you can now delete storage account in the `provisiongenie-deploy` resource group or even the entire resource group. In case you want/need to redeploy, you would need to recreate it again to successfully run the deploy script.