param workflows_ProvisionGenie_AddNotebook_name string
param resourceLocation string
param tenantURL string
param userAssignedIdentities_ProvisionGenie_ManagedIdentity_name string

resource workflows_ProvisionGenie_AddNotebook_name_resource 'Microsoft.Logic/workflows@2019-05-01' = {
  name: workflows_ProvisionGenie_AddNotebook_name
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
      parameters: {
        tenantURL: {
          defaultvalue: tenantURL

          type: 'String'
        }
      }
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
                teamId: {
                  type: 'string'
                }
                teamName: {
                  type: 'string'
                }
                teamsTechnicalName: {
                  type: 'string'
                }
              }
              type: 'object'
            }
          }
        }
      }
      actions: {
        'HTTP_-_Add_Notebook_to_channel_general': {
          runAfter: {
            Initialize_variable_Notebook_URL: [
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
              configuration: {
                contentUrl: '@{variables(\'URL\')}'
                entityId: ''
                removeUrl: null
                websiteUrl: '@{variables(\'URL\')}'
              }
              displayName: 'Notes'
              'teamsApp@odata.bind': 'https://graph.microsoft.com/v1.0/appCatalogs/teamsApps/0d820ecd-def2-4297-adad-78056cde7c78'
            }
            headers: {
              'Content-type': 'application/json'
            }
            method: 'POST'
            uri: 'https://graph.microsoft.com/v1.0/teams/@{triggerBody()?[\'teamId\']}/channels/@{triggerBody()?[\'channelId\']}/tabs'
          }
        }
        'HTTP_-_Trigger_Notebook_Creation': {
          runAfter: {}
          type: 'Http'
          inputs: {
            authentication: {
              audience: '@{parameters(\'tenantURL\')}'
              identity:resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_ProvisionGenie_ManagedIdentity_name)
              type: 'ManagedServiceIdentity'
            }
            headers: {
              Accept: 'application/json;odata=verbose'
            }
            method: 'POST'
            uri: '@{parameters(\'tenantURL\')}sites/@{triggerBody()?[\'teamsTechnicalName\']}/_api/web/features/add(\'f151bb39-7c3b-414f-bb36-6bf18872052f\')'
          }
        }
        Initialize_variable_Notebook_URL: {
          runAfter: {
            'HTTP_-_Trigger_Notebook_Creation': [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'URL'
                type: 'string'
                value: '@{parameters(\'tenantURL\')}sites/@{triggerBody()?[\'teamsTechnicalName\']}/SiteAssets/@{triggerBody()?[\'teamName\']}%20Notebook'
              }
            ]
          }
        }
        Response: {
          runAfter: {
            'HTTP_-_Add_Notebook_to_channel_general': [
              'Succeeded'
            ]
          }
          type: 'Response'
          kind: 'Http'
          inputs: {
            statusCode: 200
          }
        }
      }
      outputs: {}
    }
    parameters: {}
  }
}
