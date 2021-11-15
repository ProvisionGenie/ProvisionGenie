# 5. Post Deployment cleanup

Make sure that you exclude [copied values](copiedvalues.md) from any future commits to this repository- we don't want you to accidentally leak secrets.

If you wish, you can now delete storage account in the `ProvisionGenie` (or the custom name you might have picked while deploying) resource group. In case you want/need to redeploy, it will be automatically recreated to successfully run the deploy script.