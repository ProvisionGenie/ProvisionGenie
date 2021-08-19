param workflows_ProvisionGenie_Main_name string = 'ProvisionGenie-Main'
param workflows_ProvisionGenie_Welcome_name string = 'ProvisionGenie-Welcome'
param connections_commondataservice_name string = 'commondataservice'
param workflows_ProvisionGenie_CreateList_name string = 'ProvisionGenie-CreateList'
param workflows_ProvisionGenie_CreateTeam_name string = 'ProvisionGenie-CreateTeam'
param workflows_ProvisionGenie_CreateLibrary_name string = 'ProvisionGenie-CreateLibrary'
param workflows_ProvisionGenie_CreateTaskList_name string = 'ProvisionGenie-CreateTaskList'
param userAssignedIdentities_ProvisionGenie_ManagedIdentity_name string = 'ProvisionGenie-ManagedIdentity'
param resourceLocation string = resourceGroup().location
param subscriptionId string
param resourceGroupName string = 'ProvisionGenie'

@secure()
param ManagedIdentity_ObjectId string

@secure()
param ManagedIdentity_ClientId string
param WelcomePackageUrl string
param DataverseEnvironmentId string

module managedIdentityDeployment './ProvisionGenie-ManagedIdentity.bicep'= {
  name: 'managedIdentityDeployment'
  params: {
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
  }
}

module connectionsDeployment './ProvisionGenie-connections.bicep' = {
  name: 'connectionsDeployment'
  params: {
    connections_commondataservice_name: connections_commondataservice_name
    resourceLocation: resourceLocation
    subscriptionID: subscriptionId
  }
}

module createLibraryDeployment './ProvisionGenie_CreateLibrary.bicep' = {
  name: 'createLibraryDeployment'
  params: {
    resourceLocation: resourceLocation
    subscriptionId: subscriptionId
    workflows_ProvisionGenie_CreateLibrary_name: workflows_ProvisionGenie_CreateLibrary_name
    'ManagedIdentity_ClientId': ManagedIdentity_ClientId
    'ManagedIdentity_ObjectId': ManagedIdentity_ObjectId
    resourceGroupName: resourceGroupName
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
  }
}

module createListDeployment './ProvisionGenie_CreateList.bicep'  = {
  name: 'createListDeployment'
  params: {
    resourcelocation: resourceLocation
    subscriptionId: subscriptionId
    workflows_ProvisionGenie_CreateList_name: workflows_ProvisionGenie_CreateList_name
    'ManagedIdentity_ClientId': ManagedIdentity_ClientId
    'ManagedIdentity_ObjectId': ManagedIdentity_ObjectId
    resourceGroupName: resourceGroupName
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
  }
}

module createTaskListDeployment './ProvisionGenie_CreateTaskList.bicep' = {
  name: 'createTaskListDeployment'
  params: {
    resourceLocation: resourceLocation
    subscriptionId: subscriptionId
    workflows_ProvisionGenie_CreateList_name: workflows_ProvisionGenie_CreateList_name
    'ManagedIdentity_ClientId': ManagedIdentity_ClientId
    'ManagedIdentity_ObjectId': ManagedIdentity_ObjectId
    resourceGroupName: resourceGroupName
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
    workflows_ProvisionGenie_CreateTaskList_name: workflows_ProvisionGenie_CreateTaskList_name
  }
}

module createTeamDeployment './ProvisionGenie_CreateTeam.bicep' = {
  name: 'createTeamDeployment'
  params: {
    resourceLocation: resourceLocation
    subscriptionId: subscriptionId
    'ManagedIdentity_ClientId': ManagedIdentity_ClientId
    'ManagedIdentity_ObjectId': ManagedIdentity_ObjectId
    resourceGroupName: resourceGroupName
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
    workflows_ProvisionGenie_CreateTeam_name: workflows_ProvisionGenie_CreateTeam_name
  }
}

module welcomePackageDeployment './ProvisionGenie-WelcomePackage.bicep' = {
  name: 'welcomePackageDeployment'
  params: {
    resourceLocation: resourceLocation
    subscriptionId: subscriptionId
    'ManagedIdentity_ClientId': ManagedIdentity_ClientId
    'ManagedIdentity_ObjectId': ManagedIdentity_ObjectId
    resourceGroupName: resourceGroupName
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
    workflows_ProvisionGenie_Welcome_name: workflows_ProvisionGenie_Welcome_name
    WelcomePackageUrl: WelcomePackageUrl
  }
}

module MainDeployment './ProvisionGenie_main.bicep' = {
  name: 'MainDeployment'
  params: {
    resourceLocation: resourceLocation
    subscriptionId: subscriptionId
    'ManagedIdentity_ClientId': ManagedIdentity_ClientId
    'ManagedIdentity_ObjectId': ManagedIdentity_ObjectId
    resourceGroupName: resourceGroupName
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
    workflows_ProvisionGenie_Welcome_name: workflows_ProvisionGenie_Welcome_name
    connections_commondataservice_name: connections_commondataservice_name
    DataverseEnvironmentId: DataverseEnvironmentId
    workflows_ProvisionGenie_CreateLibrary_name: workflows_ProvisionGenie_CreateLibrary_name
    workflows_ProvisionGenie_CreateList_name: workflows_ProvisionGenie_CreateList_name
    workflows_ProvisionGenie_CreateTaskList_name: workflows_ProvisionGenie_CreateTaskList_name
    workflows_ProvisionGenie_CreateTeam_name: workflows_ProvisionGenie_CreateTeam_name
    workflows_ProvisionGenie_Main_name: workflows_ProvisionGenie_Main_name
  }
}
