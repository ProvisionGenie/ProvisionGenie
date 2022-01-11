param workflows_ProvisionGenie_AddPeople_name string
param userAssignedIdentities_ProvisionGenie_ManagedIdentity_name string
param resourceLocation string
param primaryDomain string


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
        primaryDomain: {
          defaultValue: primaryDomain
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
            For_each_guest: {
              foreach: '@split(triggerBody()?[\'guests\'],\'$\')'
              actions: {
                'Catch_-_send_invitation_in_case_external_is_not_yet_added_to_tenant': {
                  actions: {
                    'HTTP_-_Update_User': {
                      runAfter: {
                        Until_user_accepted_invite: [
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
                          inviteRedirectUrl: ' https://account.activedirectory.windowsazure.com/?tenantid=5461222b-b9e8-4cac-a9bf-fd41569b3e52&login_hint=@{outputs(\'Compose_UPN\')}'
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
                    Until_user_accepted_invite: {
                      actions: {
                        Condition: {
                          actions: {
                            Delay_for_4_hours: {
                              runAfter: {}
                              type: 'Wait'
                              inputs: {
                                interval: {
                                  count: 1
                                  unit: 'Minute'
                                }
                              }
                            }
                          }
                          runAfter: {
                            'HTTP_-_get_externalUserState': [
                              'Succeeded'
                            ]
                          }
                          expression: {
                            and: [
                              {
                                equals: [
                                  '@body(\'HTTP_-_get_externalUserState\')?[\'externalUserState\']'
                                  'PendingAcceptance'
                                ]
                              }
                            ]
                          }
                          type: 'If'
                        }
                        'HTTP_-_get_externalUserState': {
                          runAfter: {}
                          type: 'Http'
                          inputs: {
                            authentication: {
                              audience: 'https://graph.microsoft.com'
                              identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_ProvisionGenie_ManagedIdentity_name)
                              type: 'ManagedServiceIdentity'
                            }
                            headers: {
                              'Content-type': 'application/json'
                            }
                            method: 'GET'
                            uri: 'https://graph.microsoft.com/v1.0/users/@{body(\'HTTP_-_post_invitation\')?[\'invitedUser\']?[\'id\']}?$select=displayName,id,externalUserState'
                          }
                        }
                      }
                      runAfter: {
                        'HTTP_-_post_invitation': [
                          'Succeeded'
                        ]
                      }
                      expression: '@not(equals(body(\'HTTP_-_get_externalUserState\')?[\'externalUserState\'], \'PendingAcceptance\'))'
                      limit: {
                        count: 60
                        timeout: 'PT1H'
                      }
                      type: 'Until'
                    }
                  }
                  runAfter: {
                    'Try_-_check_if_user_is_already_added_to_tenant': [
                      'Failed'
                    ]
                  }
                  type: 'Scope'
                }
                Compose_UPN: {
                  runAfter: {}
                  type: 'Compose'
                  inputs: '@json(items(\'For_each_guest\'))?[\'UPN\']'
                }
                'HTTP_-_add_user_to_group': {
                  runAfter: {
                    'Catch_-_send_invitation_in_case_external_is_not_yet_added_to_tenant': [
                      'Succeeded'
                      'Failed'
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
                      '@@odata.id': 'https://graph.microsoft.com/v1.0/directoryObjects/@{body(\'HTTP_-_get_externalUserState\')?[\'id\']}'
                    }
                    headers: {
                      Accept: 'application/json; odata=verbose'
                      'Content-type': 'application/json; odata=verbose'
                    }
                    method: 'POST'
                    uri: 'https://graph.microsoft.com/v1.0/groups/@{triggerBody()?[\'teamId\']}/members/$ref'
                  }
                }
                'Try_-_check_if_user_is_already_added_to_tenant': {
                  actions: {
                    Compose_external_User_Email: {
                      runAfter: {}
                      type: 'Compose'
                      inputs: '@Concat(Replace(string(json(items(\'For_each_guest\'))?[\'UPN\']),\'@\',\'_\'),\'%23EXT%23@\',parameters(\'primaryDomain\'))'
                    }
                    'HTTP_-_get_user': {
                      runAfter: {
                        Compose_external_User_Email: [
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
                        uri: 'https://graph.microsoft.com/v1.0/users/@{outputs(\'Compose_external_User_Email\')}'
                      }
                    }
                  }
                  runAfter: {
                    Compose_UPN: [
                      'Succeeded'
                    ]
                  }
                  type: 'Scope'
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
