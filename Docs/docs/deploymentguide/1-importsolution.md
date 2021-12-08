# 2. Import Dataverse solution

We built ProvisionGenie by using Dataverse mostly for security reasons. We do not want to give users a way to bypass the canvas app and access data they shouldn't have access to. This concern was one of our main reasons to not use SharePoint lists to log requests as you would need to share the list with every user. That means that they could create new items, manipulate and even delete data. For more information, head over to [Architecture Decisions](../architecturedecisions.md#database).

In Dataverse, we can setup [security roles](https://docs.microsoft.com/power-platform/admin/database-security#assign-security-roles-to-users-in-an-environment-that-has-a-dataverse-database) to prevent this and we created two security roles `ProvisionGenie Admin` and `ProvisionGenie User` as part of the solution that you will import in the next steps.

You will need to create an application user and assign the security roles to it.

1. In case you don't already have an environment that you want to use for ProvisionGenie, follow these steps to [create a new environment with a database](https://docs.microsoft.com/power-platform/admin/create-environment#create-an-environment-with-a-database)

Important to know: a **Dataverse for Teams** environment is not enough - for reference read our [Architecture Decisions](../architecturedecisions.md)

2. Import our solution with

- Dataverse tables to log the requests
- ProvisionGenie canvas app as the UI
- Security role `ProvisionGenie Admin`
- Security role `Provision Genie User`

from here: [ProvisionGenie Solution](https://github.com/ProvisionGenie/ProvisionGenie/tree/main/Deployment/Solution)

In case this is the first time you import a solution, follow the steps described here: [Import a Power Platform solution](https://docs.microsoft.com/powerapps/maker/data-platform/import-update-export-solutions)

It can take a little while:

![importing solution](../media/deploymentguide/2-importsolution/PowerAppsSolutionImporting.png)

Once this step is completed, select the imported solution and check that it looks like this:

![Solution](../media/deploymentguide/2-importsolution/PowerAppsSolution.png)

- Create an application user and the assign the security role `Basic user` and security role `ProvisionGenie Admin` as part of the creation process as described here: [Create an application user](https://docs.microsoft.com/power-platform/admin/manage-application-users#create-an-application-user)

- Assign the security roles `Basic user` and `Provision Genie User` to all users that will be able to use ProvisionGenie for team creation.

  - You can assign the roles to individual people using the steps explained [here](https://docs.microsoft.com/power-platform/admin/database-security#assign-security-roles-to-users-in-an-environment-that-has-a-dataverse-database)
  - Alternatively, you can bulk assign roles to people by following the next steps:

    - Go to the [Power Platform admin center](https://admin.powerplatform.microsoft.com) and select your environment (step 1 and 2 in the guide above)

  - In the Access pane, select **See all** under **Users**

  ![Users - see all](../media/deploymentguide/2-importsolution/EnvironmentSettingsUsersSeeAll.png)

  - Select **Manage users in Dynamics 365** in the action bar at the top

  ![Manage users in Dynamics 365](../media/deploymentguide/2-importsolution/EnvironmentUsersManageInD365.png)

  - Select the users you want to assign the security role to, and afterwards select **Manage roles** in the action bar

  ![Manage roles](../media/deploymentguide/2-importsolution/EnvironmentUsersManageRoles.png)

  - In the list with security roles, select **Provision Genie user** and then **OK**

  ![Select roles](../media/deploymentguide/2-importsolution/EnvironmentUsersSelectRoles.png)

4. You need to obtain the Environment ID for a later step:

- Open [make.powerapps.com](https://make.powerapps.com)
- Select the **Settings** gear
- Select **Session details**
- The value we need here is the **Instance URL** from [make.powerapps.com](https://make.powerapps.com), save it here: [copied values](copiedvalues.md)

![Power Apps session details](../media/deploymentguide/2-importsolution/PAStudioSessionDetails.png)