param workflows_ProvisionGenie_Welcome_name string
param userAssignedIdentities_ProvisionGenie_ManagedIdentity_name string
param resourceLocation string
param WelcomePackageUrl string

resource workflows_ProvisionGenie_Welcome_name_resource 'Microsoft.Logic/workflows@2019-05-01' = {
  name: workflows_ProvisionGenie_Welcome_name
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
        'Welcome package url': {
          defaultValue: WelcomePackageUrl
          type: 'String'
        }
      }
      triggers: {
        manual: {
          type: 'Request'
          kind: 'Http'
          inputs: {
            method: 'POST'
            schema: {
              properties: {
                Owner: {
                  type: 'string'
                }
                TeamId: {
                  type: 'string'
                }
              }
              type: 'object'
            }
          }
        }
      }
      actions: {
        Get_First_Channel: {
          runAfter: {
            Parse_Channel_info: [
              'Succeeded'
            ]
          }
          type: 'Compose'
          inputs: '@first(body(\'Parse_Channel_info\')?[\'value\'])'
          description: 'The first channel is the General channel'
        }
        HTTP_Get_channels: {
          runAfter: {
            Owner: [
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
            method: 'GET'
            uri: 'https://graph.microsoft.com/v1.0/teams/@{variables(\'TeamId\')}/channels'
          }
          description: 'Get all channels present in the team'
        }
        HTTP_pin_training_material: {
          runAfter: {
            Get_First_Channel: [
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
                contentUrl: '@{parameters(\'Welcome package url\')}'
                entityId: ''
                removeUrl: null
                websiteUrl: '@{parameters(\'Welcome package url\')}'
              }
              displayName: 'Training Material'
              'teamsApp@odata.bind': 'https://graph.microsoft.com/v1.0/appCatalogs/teamsApps/com.microsoft.teamspace.tab.web'
            }
            headers: {
              'content-type': 'application/json'
            }
            method: 'POST'
            uri: 'https://graph.microsoft.com/v1.0/teams/@{variables(\'TeamId\')}/channels/@{outputs(\'Get_First_Channel\')?[\'id\']}/tabs'
          }
          description: 'Pin a document library with training material to the General channel'
        }
        Owner: {
          runAfter: {
            TeamId: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'Owner'
                type: 'string'
                value: '@body(\'Parse_trigger_body\')?[\'Owner\']'
              }
            ]
          }
        }
        Parse_Channel_info: {
          runAfter: {
            HTTP_Get_channels: [
              'Succeeded'
            ]
          }
          type: 'ParseJson'
          inputs: {
            content: '@body(\'HTTP_Get_channels\')'
            schema: {
              properties: {
                '@@odata.context': {
                  type: 'string'
                }
                '@@odata.count': {
                  type: 'integer'
                }
                value: {
                  items: {
                    properties: {
                      description: {
                        type: [
                          'string'
                          'null'
                        ]
                      }
                      displayName: {
                        type: 'string'
                      }
                      email: {
                        type: 'string'
                      }
                      id: {
                        type: 'string'
                      }
                      isFavoriteByDefault: {}
                      membershipType: {
                        type: 'string'
                      }
                      webUrl: {
                        type: 'string'
                      }
                    }
                    required: [
                      'id'
                      'displayName'
                      'description'
                      'isFavoriteByDefault'
                      'email'
                      'webUrl'
                      'membershipType'
                    ]
                    type: 'object'
                  }
                  type: 'array'
                }
              }
              type: 'object'
            }
          }
        }
        Parse_trigger_body: {
          runAfter: {}
          type: 'ParseJson'
          inputs: {
            content: '@triggerBody()'
            schema: {
              properties: {
                Owner: {
                  type: 'string'
                }
                TeamId: {
                  type: 'string'
                }
              }
              type: 'object'
            }
          }
        }
        Response: {
          runAfter: {
            HTTP_pin_training_material: [
              'Succeeded'
            ]
          }
          type: 'Response'
          kind: 'Http'
          inputs: {
            statusCode: 200
          }
        }
        TeamId: {
          runAfter: {
            Parse_trigger_body: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'TeamId'
                type: 'string'
                value: '@body(\'Parse_trigger_body\')?[\'TeamId\']'
              }
            ]
          }
        }
      }
      outputs: {}
    }
    parameters: {}
  }
}
