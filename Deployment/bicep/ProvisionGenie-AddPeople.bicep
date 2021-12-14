param workflows_ProvisionGenie_AddPeople_name string
param userAssignedIdentities_ProvisionGenie_ManagedIdentity_name string
param resourceLocation string

resource workflows_ProvisionGenie_AddPeople_name_resource 'Microsoft.Logic/workflows@2019-05-01' = {
  name: workflows_ProvisionGenie_AddPeople_name
  location: resourceLocation
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${resourceId('Microsoft.ManagedIdentity/userAssignedIdentities/', userAssignedIdentities_ProvisionGenie_ManagedIdentity_name)}': {}
    }
  }
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {}
      triggers: {
        manual: {
          type: 'Request'
          kind: 'Http'
          inputs: {
            schema: {
              properties: {
                members: {
                  type: 'string'
                }
                owners: {
                  type: 'string'
                }
                teamId: {
                  type: 'string'
                }
              }
              type: 'object'
            }
          }
        }
      }
      actions: {
        Initialize_variable_People: {
          runAfter: {}
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'People'
                type: 'array'
              }
            ]
          }
        }
        Response: {
          runAfter: {
            Scope_add_people: [
              'Succeeded'
            ]
          }
          type: 'Response'
          kind: 'Http'
          inputs: {
            statusCode: 200
          }
        }
        Scope_add_people: {
          actions: {
            For_each_member: {
              foreach: '@split(triggerBody()?[\'members\'],\';\')'
              actions: {
                Append_to_array_variable: {
                  runAfter: {}
                  type: 'AppendToArrayVariable'
                  inputs: {
                    name: 'People'
                    value: {
                      '@@odata.type': 'microsoft.graph.aadUserConversationMember'
                      roles: []
                      'user@odata.bind': 'https://graph.microsoft.com/v1.0/users(\'@{items(\'For_each_member\')}\')'
                    }
                  }
                }
              }
              runAfter: {}
              type: 'Foreach'
            }
            For_each_owner: {
              foreach: '@split(triggerBody()?[\'owners\'],\';\')'
              actions: {
                Append_to_array_variable_2: {
                  runAfter: {}
                  type: 'AppendToArrayVariable'
                  inputs: {
                    name: 'People'
                    value: {
                      '@@odata.type': 'microsoft.graph.aadUserConversationMember'
                      roles: [
                        'owner'
                      ]
                      'user@odata.bind': 'https://graph.microsoft.com/v1.0/users(\'@{items(\'For_each_owner\')}\')'
                    }
                  }
                }
              }
              runAfter: {
                For_each_member: [
                  'Succeeded'
                ]
              }
              type: 'Foreach'
            }
            HTTP_add_members_and_owners: {
              runAfter: {
                For_each_owner: [
                  'Succeeded'
                ]
              }
              type: 'Http'
              inputs: {
                authentication: {
                  audience: 'https://graph.microsoft.com'
                  identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_ProvisionGenie_ManagedIdentity_name)
                  type: 'ManagedServiceIdentity'
                }
                body: {
                  values: '@variables(\'People\')'
                }
                headers: {
                  'Content-type': 'application/json'
                }
                method: 'POST'
                uri: 'https://graph.microsoft.com/v1.0/teams/@{triggerBody()?[\'teamId\']}/members/add'
              }
            }
          }
          runAfter: {
            Initialize_variable_People: [
              'Succeeded'
            ]
          }
          type: 'Scope'
        }
      }
      outputs: {}
    }
    parameters: {}
  }
}
