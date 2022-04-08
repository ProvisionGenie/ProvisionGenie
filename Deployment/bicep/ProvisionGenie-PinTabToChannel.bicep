param workflows_ProvisionGenie_PinTabToChannel_name string
param userAssignedIdentities_ProvisionGenie_ManagedIdentity_name string
param resourceLocation string

resource workflows_ProvisionGenie_PinTabToChannel_name_resource 'Microsoft.Logic/workflows@2019-05-01' = {
  name: workflows_ProvisionGenie_PinTabToChannel_name
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
                channelId: {
                  type: 'string'
                }
                tabName: {
                  type: 'string'
                }
                tabType: {
                  type: 'string'
                }
                tabUrl: {
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
        Configuration: {
          runAfter: {}
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'Configuration'
                type: 'string'
              }
            ]
          }
        }
        HTTP: {
          runAfter: {
            Switch_TabType: [
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
            body: '@variables(\'Configuration\')'
            headers: {
              'content-type': 'application/json'
            }
            method: 'POST'
            uri: 'https://graph.microsoft.com/v1.0/teams/@{triggerBody()?[\'teamId\']}/channels/@{triggerBody()?[\'channelId\']}/tabs'
          }
        }
        Response: {
          runAfter: {
            HTTP: [
              'Succeeded'
            ]
          }
          type: 'Response'
          kind: 'Http'
          inputs: {
            statusCode: 200
          }
        }
        Switch_TabType: {
          runAfter: {
            Configuration: [
              'Succeeded'
            ]
          }
          cases: {
            Case_Library: {
              case: 'Library'
              actions: {
                Set_Configuration_for_Library: {
                  runAfter: {}
                  type: 'SetVariable'
                  inputs: {
                    name: 'Configuration'
                    value: '{\n  "configuration": {\n    "contentUrl": "@{triggerBody()?[\'tabUrl\']}",\n    "entityId": "",\n    "removeUrl": null,\n    "websiteUrl": "@{triggerBody()?[\'tabUrl\']}",\n  },\n  "displayName": "@{triggerBody()?[\'tabName\']}",\n  "teamsApp@odata.bind": "https://graph.microsoft.com/v1.0/appCatalogs/teamsApps/com.microsoft.teamspace.tab.web"\n}'
                  }
                }
              }
            }
            Case_List: {
              case: 'List'
              actions: {
                Set_Configuration_for_List: {
                  runAfter: {}
                  type: 'SetVariable'
                  inputs: {
                    name: 'Configuration'
                    value: '{\n  "configuration": {\n    "contentUrl": "@{triggerBody()?[\'tabUrl\']}",\n    "entityId": "",\n    "removeUrl": null,\n    "websiteUrl": "@{triggerBody()?[\'tabUrl\']}"\n  },\n  "displayName": "@{triggerBody()?[\'tabName\']}",\n  "teamsApp@odata.bind": "https://graph.microsoft.com/v1.0/appCatalogs/teamsApps/com.microsoft.teamspace.tab.web"\n}'
                  }
                  description: 'Configuration for List tabs is not supported, therefore we create a website tab instead'
                }
              }
            }
          }
          default: {
            actions: {}
          }
          expression: '@triggerBody()?[\'tabType\']'
          type: 'Switch'
        }
      }
      outputs: {}
    }
    parameters: {}
  }
}
