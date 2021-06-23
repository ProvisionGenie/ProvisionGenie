param userAssignedIdentities_ProvisionGenie_ManagedIdentity_name string

resource userAssignedIdentities_ProvisionGenie_ManagedIdentity_name_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userAssignedIdentities_ProvisionGenie_ManagedIdentity_name
  location: 'westeurope'
}
