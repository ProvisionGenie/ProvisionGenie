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

module managedIdentityDeployment '?' /*TODO: replace with correct path to ProvisionGenie-ManagedIdentity.json*/ = {
  name: 'managedIdentityDeployment'
  params: {
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
  }
}

module connectionsDeployment '?' /*TODO: replace with correct path to ProvisionGenie-connections.json*/ = {
  name: 'connectionsDeployment'
  params: {
    connections_commondataservice_name: connections_commondataservice_name
    resourceLocation: resourceLocation
    subscriptionID: subscriptionId
  }
}

module createLibraryDeployment '?' /*TODO: replace with correct path to ProvisionGenie-CreateLibrary.json*/ = {
  name: 'createLibraryDeployment'
  params: {
    resourceLocation: resourceLocation
    subscriptionID: subscriptionId
    workflows_ProvisionGenie_CreateLibrary_name: workflows_ProvisionGenie_CreateLibrary_name
    'ManagedIdentity-ClientId': ManagedIdentity_ClientId
    'ManagedIdentity-ObjectId': ManagedIdentity_ObjectId
    resourceGroupName: resourceGroupName
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
  }
}

module createListDeployment '?' /*TODO: replace with correct path to ProvisionGenie-CreateList.json*/ = {
  name: 'createListDeployment'
  params: {
    resourceLocation: resourceLocation
    subscriptionID: subscriptionId
    workflows_ProvisionGenie_CreateList_name: workflows_ProvisionGenie_CreateList_name
    'ManagedIdentity-ClientId': ManagedIdentity_ClientId
    'ManagedIdentity-ObjectId': ManagedIdentity_ObjectId
    resourceGroupName: resourceGroupName
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
  }
}

module createTaskListDeployment '?' /*TODO: replace with correct path to ProvisionGenie-CreateTaskList.json*/ = {
  name: 'createTaskListDeployment'
  params: {
    resourceLocation: resourceLocation
    subscriptionID: subscriptionId
    workflows_ProvisionGenie_CreateList_name: workflows_ProvisionGenie_CreateList_name
    'ManagedIdentity-ClientId': ManagedIdentity_ClientId
    'ManagedIdentity-ObjectId': ManagedIdentity_ObjectId
    resourceGroupName: resourceGroupName
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
    workflows_ProvisionGenie_CreateTaskList_name: workflows_ProvisionGenie_CreateTaskList_name
  }
}

module createTeamDeployment '?' /*TODO: replace with correct path to ProvisionGenie-CreateTeam.json*/ = {
  name: 'createTeamDeployment'
  params: {
    resourceLocation: resourceLocation
    subscriptionID: subscriptionId
    'ManagedIdentity-ClientId': ManagedIdentity_ClientId
    'ManagedIdentity-ObjectId': ManagedIdentity_ObjectId
    resourceGroupName: resourceGroupName
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
    workflows_ProvisionGenie_CreateTeam_name: workflows_ProvisionGenie_CreateTeam_name
  }
}

module welcomePackageDeployment '?' /*TODO: replace with correct path to ProvisionGenie-WelcomePackage.json*/ = {
  name: 'welcomePackageDeployment'
  params: {
    resourceLocation: resourceLocation
    subscriptionID: subscriptionId
    'ManagedIdentity-ClientId': ManagedIdentity_ClientId
    'ManagedIdentity-ObjectId': ManagedIdentity_ObjectId
    resourceGroupName: resourceGroupName
    userAssignedIdentities_ProvisionGenie_ManagedIdentity_name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
    workflows_ProvisionGenie_Welcome_name: workflows_ProvisionGenie_Welcome_name
    WelcomePackageUrl: WelcomePackageUrl
  }
}

module MainDeployment '?' /*TODO: replace with correct path to ProvisionGenie-main.json*/ = {
  name: 'MainDeployment'
  params: {
    resourceLocation: resourceLocation
    subscriptionID: subscriptionId
    'ManagedIdentity-ClientId': ManagedIdentity_ClientId
    'ManagedIdentity-ObjectId': ManagedIdentity_ObjectId
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
