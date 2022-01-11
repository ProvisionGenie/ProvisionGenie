param connections_commondataservice_name string = 'commondataservice'
param workflows_ProvisionGenie_Main_name string = 'ProvisionGenie-Main'
param workflows_ProvisionGenie_Welcome_name string = 'ProvisionGenie-Welcome'
param workflows_ProvisionGenie_AddNotebook_name string = 'ProvisionGenie-AddNotebook'
param workflows_ProvisionGenie_AddPeople_name string = 'ProvisionGenie-AddPeople'
param workflows_ProvisionGenie_CreateList_name string = 'ProvisionGenie-CreateList'
param workflows_ProvisionGenie_CreateTeam_name string = 'ProvisionGenie-CreateTeam'
param workflows_ProvisionGenie_CreateLibrary_name string = 'ProvisionGenie-CreateLibrary'
param workflows_ProvisionGenie_CreateTaskList_name string = 'ProvisionGenie-CreateTaskList'
param userAssignedIdentities_ProvisionGenie_ManagedIdentity_name string = 'ProvisionGenie-ManagedIdentity'
param resourceLocation string = resourceGroup().location
param WelcomePackageUrl string
param DataverseEnvironmentId string
param servicePrincipal_AppId string
param tenantURL string = 'tenantURL'

@secure()
param servicePrincipal_ClientSecret string
param servicePrincipal_TenantId string

module managedIdentityDeployment 'ProvisionGenie-ManagedIdentity.bicep' = {
  name: 'managedIdentityDeployment'
  params: {
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
    resourceLocation: resourceLocation
  }
}

module connectionsDeployment 'ProvisionGenie-connections.bicep' = {
  name: 'connectionsDeployment'
  params: {
    connections_commondataservice_name: connections_commondataservice_name
    resourceLocation: resourceLocation
    servicePrincipal_AppId: servicePrincipal_AppId
    servicePrincipal_ClientSecret: servicePrincipal_ClientSecret
    servicePrincipal_TenantId: servicePrincipal_TenantId
  }
}

module createLibraryDeployment ' ProvisionGenie-CreateLibrary.bicep' = {
  name: 'createLibraryDeployment'
  params: {
    resourceLocation: resourceLocation
    workflows_ProvisionGenie_CreateLibrary_name: workflows_ProvisionGenie_CreateLibrary_name
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
  }
  dependsOn: [
    managedIdentityDeployment
  ]
}

module addPeopleDeployment 'ProvisionGenie-AddPeople.bicep' = {
  name: 'addPeopleDeployment'
  params: {
    resourceLocation: resourceLocation
    workflows_ProvisionGenie_AddPeople_name: workflows_ProvisionGenie_AddPeople_name
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
  }
  dependsOn: [
    managedIdentityDeployment
  ]
}

module createListDeployment 'ProvisionGenie-CreateList.bicep' = {
  name: 'createListDeployment'
  params: {
    resourceLocation: resourceLocation
    workflows_ProvisionGenie_CreateList_name: workflows_ProvisionGenie_CreateList_name
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
  }
  dependsOn: [
    managedIdentityDeployment
  ]
}

module createTaskListDeployment 'ProvisionGenie-CreateTaskList.bicep' = {
  name: 'createTaskListDeployment'
  params: {
    resourceLocation: resourceLocation
    workflows_ProvisionGenie_CreateList_name: workflows_ProvisionGenie_CreateList_name
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
    workflows_ProvisionGenie_CreateTaskList_name: workflows_ProvisionGenie_CreateTaskList_name
  }
  dependsOn: [
    managedIdentityDeployment
    createListDeployment
  ]
}

module createTeamDeployment 'ProvisionGenie-CreateTeam.bicep' = {
  name: 'createTeamDeployment'
  params: {
    resourceLocation: resourceLocation
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
    workflows_ProvisionGenie_CreateTeam_name: workflows_ProvisionGenie_CreateTeam_name
   
  }
  dependsOn: [
    managedIdentityDeployment
  ]
}

module welcomePackageDeployment 'ProvisionGenie-WelcomePackage.bicep' = {
  name: 'welcomePackageDeployment'
  params: {
    resourceLocation: resourceLocation
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
    workflows_ProvisionGenie_Welcome_name: workflows_ProvisionGenie_Welcome_name
    WelcomePackageUrl: WelcomePackageUrl
  }
  dependsOn: [
    managedIdentityDeployment
  ]
}

module addNotebookDeployment 'ProvisionGenie-AddNotebook.bicep' = {
  name: 'addNotebookDeployment'
  params: {
    resourceLocation: resourceLocation
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
    workflows_ProvisionGenie_AddNotebook_name: workflows_ProvisionGenie_AddNotebook_name
    tenantURL:tenantURL
   
  }
  dependsOn: [
    managedIdentityDeployment
  ]
}

module MainDeployment 'ProvisionGenie-main.bicep' = {
  name: 'MainDeployment'
  params: {
    resourceLocation: resourceLocation
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
    workflows_ProvisionGenie_Welcome_name: workflows_ProvisionGenie_Welcome_name
    connections_commondataservice_name: connections_commondataservice_name
    DataverseEnvironmentId: DataverseEnvironmentId
    workflows_ProvisionGenie_CreateLibrary_name: workflows_ProvisionGenie_CreateLibrary_name
    workflows_ProvisionGenie_CreateList_name: workflows_ProvisionGenie_CreateList_name
    workflows_ProvisionGenie_CreateTaskList_name: workflows_ProvisionGenie_CreateTaskList_name
    workflows_ProvisionGenie_CreateTeam_name: workflows_ProvisionGenie_CreateTeam_name
    workflows_ProvisionGenie_Main_name: workflows_ProvisionGenie_Main_name
    workflows_ProvisionGenie_AddPeople_name: workflows_ProvisionGenie_AddPeople_name
    workflows_ProvisionGenie_AddNotebook_name: workflows_ProvisionGenie_AddNotebook_name
  }
  dependsOn: [
    connectionsDeployment
    managedIdentityDeployment
    createListDeployment
    createTaskListDeployment
    createTeamDeployment
    createLibraryDeployment
    welcomePackageDeployment
    addPeopleDeployment
    addNotebookDeployment
  ]
}
