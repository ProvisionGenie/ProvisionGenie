param workflows_ProvisionGenie_AddPeople_name string
param userAssignedIdentities_ProvisionGenie_ManagedIdentity_name string
param resourceLocation string
param tenantId string


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
      parameters: {
        tenantId: {
          defaultValue: tenantId
          type: 'String'
        }
      }
      triggers: {
        manual: {
          type: 'Request'
          kind: 'Http'
          inputs: {
            schema: {
              members: {
                type: 'string'
              }
              owners: {
                type: 'string'
              }
              properties: {
                guests: '{\r\n "Organization": {\r\n "type": "string"\r\n  },\r\n  "UPN": {\r\n  "type": "string"\r\n },\r\n  "firstName": {\r\n "type": "string"\r\n },\r\n "lastName": {\r\n  "type": "string"\r\n  }\r\n }'
                type: 'string'
              }
              teamId: {
                type: 'string'
              }
              teamName: {
                type: 'string'
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
            For_each_guest: {
              foreach: '@split(triggerBody()?[\'guests\'],\'$\')'
              actions: {
                Compose_UPN: {
                  runAfter: {}
                  type: 'Compose'
                  inputs: '@json(items(\'For_each_guest\'))?[\'UPN\']'
                }
                Condition: {
                  actions: {
                    'HTTP_-_add_user_to_this_group': {
                      runAfter: {}
                      type: 'Http'
                      inputs: {
                        authentication: {
                          audience: 'https://graph.microsoft.com'
                          identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_ProvisionGenie_ManagedIdentity_name)
                          type: 'ManagedServiceIdentity'
                        }
                        body: {
                          '@@odata.id': 'https://graph.microsoft.com/v1.0/directoryObjects/@{body(\'HTTP_-_get_user\')?[\'value\'][0]?[\'id\']}'
                        }
                        headers: {
                          '': 'application/json; odata=verbose'
                          Accept: 'application/json; odata=verbose'
                        }
                        method: 'POST'
                        uri: 'https://graph.microsoft.com/v1.0/groups/@{triggerBody()?[\'teamId\']}/members/$ref'
                      }
                    }
                  }
                  runAfter: {
                    'HTTP_-_get_user': [
                      'Succeeded'
                    ]
                  }
                  else: {
                    actions: {
                      'HTTP_-_Update_User': {
                        runAfter: {
                          'HTTP_-_post_invitation': [
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
                            companyName: '@{json(triggerBody()?[\'guests\'])?[\'Organization\']}'
                            displayName: '@{Concat(json(triggerBody()?[\'guests\'])?[\'firstName\'],\' \',json(triggerBody()?[\'guests\'])?[\'lastName\'])}'
                            givenName: '@{json(triggerBody()?[\'guests\'])?[\'firstName\']}'
                            surname: '@{json(triggerBody()?[\'guests\'])?[\'lastName\']}'
                          }
                          headers: {
                            'Content-type': 'application/json'
                          }
                          method: 'PATCH'
                          uri: 'https://graph.microsoft.com/v1.0/users/@{body(\'HTTP_-_post_invitation\')?[\'invitedUser\']?[\'id\']}'
                        }
                      }
                      'HTTP_-_add_user_to_group': {
                        runAfter: {
                          'HTTP_-_Update_User': [
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
                            '@@odata.id': 'https://graph.microsoft.com/v1.0/directoryObjects/@{body(\'HTTP_-_post_invitation\')?[\'inviteduser\']?[\'id\']}'
                          }
                          headers: {
                            Accept: 'application/json; odata=verbose'
                            'Content-type': 'application/json; odata=verbose'
                          }
                          method: 'POST'
                          uri: 'https://graph.microsoft.com/v1.0/groups/@{triggerBody()?[\'teamId\']}/members/$ref'
                        }
                      }
                      'HTTP_-_post_invitation': {
                        runAfter: {}
                        type: 'Http'
                        inputs: {
                          authentication: {
                            audience: 'https://graph.microsoft.com'
                            identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_ProvisionGenie_ManagedIdentity_name)
                            type: 'ManagedServiceIdentity'
                          }
                          body: {
                            inviteRedirectUrl: 'https://account.activedirectory.windowsazure.com/?tenantid=@{parameters(\'tenantId\')}&login_hint=@{outputs(\'Compose_UPN\')}'
                            invitedUserEmailAddress: '@{outputs(\'Compose_UPN\')}'
                            sendInvitationMessage: true
                          }
                          headers: {
                            'content-type': 'application/json'
                          }
                          method: 'POST'
                          uri: 'https://graph.microsoft.com/v1.0/invitations'
                        }
                      }
                    }
                  }
                  expression: {
                    and: [
                      {
                        greater: [
                          '@length(body(\'HTTP_-_get_user\')?[\'value\'])'
                          0
                        ]
                      }
                    ]
                  }
                  type: 'If'
                }
                'HTTP_-_get_user': {
                  runAfter: {
                    Compose_UPN: [
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
                    headers: {
                      'Content-Type': 'application/json'
                    }
                    method: 'GET'
                    uri: 'https://graph.microsoft.com/v1.0/users/?$filter=mail%20eq%20\'@{outputs(\'Compose_UPN\')}\''
                  }
                }
              }
              runAfter: {
                HTTP_add_members_and_owners: [
                  'Succeeded'
                ]
              }
              type: 'Foreach'
            }
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
