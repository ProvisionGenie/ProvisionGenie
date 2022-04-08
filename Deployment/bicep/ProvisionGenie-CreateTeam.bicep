param userAssignedIdentities_ProvisionGenie_ManagedIdentity_name string
param resourceLocation string
param workflows_ProvisionGenie_CreateTeam_name string

resource workflows_ProvisionGenie_CreateTeam_name_resource 'Microsoft.Logic/workflows@2019-05-01' = {
  name: workflows_ProvisionGenie_CreateTeam_name
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
      staticResults: {
        HTTP_delete_wiki_tab0: {
          status: 'Succeeded'
          outputs: {
            headers: {}
            statusCode: 'OK'
          }
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
                Channels: {
                  items: {
                    properties: {
                      description: {
                        type: 'string'
                      }
                      displayName: {
                        type: 'string'
                      }
                    }
                    required: [
                      'displayName'
                      'description'
                    ]
                    type: 'object'
                  }
                  type: 'array'
                }
                Description: {
                  type: 'string'
                }
                'Display Name': {
                  type: 'string'
                }
                'Owner UPN': {
                  type: 'string'
                }
                'Technical Name': {
                  type: 'string'
                }
              }
              type: 'object'
            }
          }
        }
      }
      actions: {
        Configure_Channels: {
          actions: {
            For_each_channel: {
              foreach: '@body(\'Parse_channel_info\')?[\'value\']'
              actions: {
                Append_to_array_variable: {
                  runAfter: {
                    For_each_wiki_tab: [
                      'Succeeded'
                    ]
                  }
                  type: 'AppendToArrayVariable'
                  inputs: {
                    name: 'ChannelInfo'
                    value: {
                      Id: '@{items(\'For_each_channel\')?[\'id\']}'
                      Name: '@{items(\'For_each_channel\')?[\'displayName\']}'
                    }
                  }
                }
                For_each_wiki_tab: {
                  foreach: '@body(\'Parse_wiki_tab_info\')?[\'value\']'
                  actions: {
                    HTTP_delete_wiki_tab: {
                      runAfter: {}
                      type: 'Http'
                      inputs: {
                        authentication: {
                          audience: 'https://graph.microsoft.com'
                          identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_ProvisionGenie_ManagedIdentity_name)
                          type: 'ManagedServiceIdentity'
                        }
                        method: 'DELETE'
                        uri: 'https://graph.microsoft.com/v1.0/teams/@{variables(\'TeamGroupId\')}/channels/@{items(\'For_each_channel\')?[\'id\']}/tabs/@{items(\'For_each_wiki_tab\')?[\'id\']}'
                      }
                      runtimeConfiguration: {
                        staticResult: {
                          staticResultOptions: 'Disabled'
                          name: 'HTTP_delete_wiki_tab0'
                        }
                      }
                    }
                  }
                  runAfter: {
                    Parse_wiki_tab_info: [
                      'Succeeded'
                    ]
                  }
                  type: 'Foreach'
                }
                HTTP_get_file_folder: {
                  runAfter: {}
                  type: 'Http'
                  inputs: {
                    authentication: {
                      audience: 'https://graph.microsoft.com'
                      identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_ProvisionGenie_ManagedIdentity_name)
                      type: 'ManagedServiceIdentity'
                    }
                    method: 'GET'
                    uri: 'https://graph.microsoft.com/v1.0/teams/@{variables(\'TeamGroupId\')}/channels/@{items(\'For_each_channel\')?[\'id\']}/filesFolder'
                  }
                }
                HTTP_get_wiki_tab: {
                  runAfter: {
                    HTTP_get_file_folder: [
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
                    uri: 'https://graph.microsoft.com/beta/teams/@{variables(\'TeamGroupId\')}/channels/@{items(\'For_each_channel\')?[\'id\']}/tabs?$filter=displayName eq \'Wiki\''
                  }
                }
                Parse_wiki_tab_info: {
                  runAfter: {
                    HTTP_get_wiki_tab: [
                      'Succeeded'
                    ]
                  }
                  type: 'ParseJson'
                  inputs: {
                    content: '@body(\'HTTP_get_wiki_tab\')'
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
                              configuration: {
                                properties: {
                                  contentUrl: {}
                                  entityId: {}
                                  hasContent: {
                                    type: 'boolean'
                                  }
                                  removeUrl: {}
                                  websiteUrl: {}
                                  wikiDefaultTab: {
                                    type: 'boolean'
                                  }
                                  wikiTabId: {
                                    type: 'integer'
                                  }
                                }
                                type: 'object'
                              }
                              displayName: {
                                type: 'string'
                              }
                              id: {
                                type: 'string'
                              }
                              messageId: {}
                              sortOrderIndex: {
                                type: 'string'
                              }
                              teamsAppId: {}
                              webUrl: {
                                type: 'string'
                              }
                            }
                            required: [
                              'id'
                              'displayName'
                              'teamsAppId'
                              'sortOrderIndex'
                              'messageId'
                              'webUrl'
                              'configuration'
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
              }
              runAfter: {
                Parse_channel_info: [
                  'Succeeded'
                ]
              }
              type: 'Foreach'
              description: 'Remove the wiki from each created channel'
            }
            HTTP_get_channels: {
              runAfter: {}
              type: 'Http'
              inputs: {
                authentication: {
                  audience: 'https://graph.microsoft.com'
                  identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_ProvisionGenie_ManagedIdentity_name)
                  type: 'ManagedServiceIdentity'
                }
                method: 'GET'
                uri: 'https://graph.microsoft.com/v1.0/teams/@{variables(\'TeamGroupId\')}/channels'
              }
            }
            Parse_channel_info: {
              runAfter: {
                HTTP_get_channels: [
                  'Succeeded'
                ]
              }
              type: 'ParseJson'
              inputs: {
                content: '@body(\'HTTP_get_channels\')'
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
          }
          runAfter: {
            Ensure_Team_Exists: [
              'Succeeded'
            ]
          }
          type: 'Scope'
        }
        Ensure_Group_Exists: {
          actions: {
            Does_Group_exist: {
              actions: {
                Set_TeamGroupId_to_existing_value: {
                  runAfter: {}
                  type: 'SetVariable'
                  inputs: {
                    name: 'TeamGroupId'
                    value: '@{body(\'Get_Group_for_technical_name\')[\'value\'][0][\'id\']}'
                  }
                }
              }
              runAfter: {
                Get_Group_for_technical_name: [
                  'Succeeded'
                ]
              }
              else: {
                actions: {
                  HTTP_create_group: {
                    runAfter: {
                      HTTP_get_owner_info: [
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
                        description: '@{triggerBody()?[\'Description\']}'
                        displayName: '@{triggerBody()?[\'Display Name\']}'
                        groupTypes: [
                          'Unified'
                        ]
                        mailEnabled: true
                        mailNickname: '@{triggerBody()?[\'Technical Name\']}'
                        'members@odata.bind': [
                          'https://graph.microsoft.com/v1.0/users/@{body(\'HTTP_get_owner_info\')[\'id\']}'
                        ]
                        'owners@odata.bind': [
                          'https://graph.microsoft.com/v1.0/users/@{body(\'HTTP_get_owner_info\')[\'id\']}'
                        ]
                        resourceBehaviorOptions: [
                          'HideGroupInOutlook'
                          'SubscribeMembersToCalendarEventsDisabled'
                          'WelcomeEmailDisabled'
                        ]
                        securityEnabled: false
                        visibility: 'Private'
                      }
                      headers: {
                        'Content-type': 'application/json'
                      }
                      method: 'POST'
                      uri: 'https://graph.microsoft.com/v1.0/groups'
                    }
                  }
                  HTTP_get_owner_info: {
                    runAfter: {}
                    type: 'Http'
                    inputs: {
                      authentication: {
                        audience: 'https://graph.microsoft.com'
                        identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_ProvisionGenie_ManagedIdentity_name)
                        type: 'ManagedServiceIdentity'
                      }
                      method: 'GET'
                      uri: 'https://graph.microsoft.com/v1.0/users/@{triggerBody()?[\'Owner UPN\']}'
                    }
                  }
                  Set_TeamGroupId_to_created_group_id: {
                    runAfter: {
                      HTTP_create_group: [
                        'Succeeded'
                      ]
                    }
                    type: 'SetVariable'
                    inputs: {
                      name: 'TeamGroupId'
                      value: '@{body(\'HTTP_create_group\')[\'id\']}'
                    }
                  }
                }
              }
              expression: {
                and: [
                  {
                    not: {
                      equals: [
                        '@length(body(\'Get_Group_for_technical_name\')?[\'Value\'])'
                        0
                      ]
                    }
                  }
                ]
              }
              type: 'If'
            }
            Get_Group_for_technical_name: {
              runAfter: {}
              type: 'Http'
              inputs: {
                authentication: {
                  audience: 'https://graph.microsoft.com'
                  identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_ProvisionGenie_ManagedIdentity_name)
                  type: 'ManagedServiceIdentity'
                }
                method: 'GET'
                uri: 'https://graph.microsoft.com/v1.0/groups?$filter=mailNickname eq \'@{triggerBody()?[\'Technical Name\']}\'&$select=id,displayName,mailNickname&$count=true&$top=1'
              }
            }
          }
          runAfter: {
            Initialize_ChannelInfo: [
              'Succeeded'
            ]
          }
          type: 'Scope'
        }
        Ensure_Team_Exists: {
          actions: {
            Does_Team_exist: {
              actions: {}
              runAfter: {
                HTTP_Get_Team: [
                  'Succeeded'
                  'Failed'
                ]
              }
              else: {
                actions: {
                  Until_Team_upgrade_accepted: {
                    actions: {
                      HTTP_update_group_to_team: {
                        runAfter: {}
                        type: 'Http'
                        inputs: {
                          authentication: {
                            audience: 'https://graph.microsoft.com'
                            identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_ProvisionGenie_ManagedIdentity_name)
                            type: 'ManagedServiceIdentity'
                          }
                          body: {
                            channels: '@triggerBody()?[\'Channels\']'
                            'group@odata.bind': 'https://graph.microsoft.com/v1.0/groups(\'@{variables(\'TeamGroupId\')}\')'
                            'template@odata.bind': 'https://graph.microsoft.com/v1.0/teamsTemplates(\'standard\')'
                          }
                          headers: {
                            'content-type': 'application/json'
                          }
                          method: 'POST'
                          uri: 'https://graph.microsoft.com/v1.0/teams'
                        }
                      }
                      Set_TeamCreationRequestCode_to_Status_code: {
                        runAfter: {
                          HTTP_update_group_to_team: [
                            'Succeeded'
                            'Failed'
                          ]
                        }
                        type: 'SetVariable'
                        inputs: {
                          name: 'TeamCreationRequestCode'
                          value: '@{outputs(\'HTTP_update_group_to_team\')[\'statusCode\']}'
                        }
                      }
                      Validate_StatusCode: {
                        actions: {
                          Delay_10_seconds_for_404: {
                            runAfter: {}
                            type: 'Wait'
                            inputs: {
                              interval: {
                                count: 10
                                unit: 'Second'
                              }
                            }
                          }
                        }
                        runAfter: {
                          Set_TeamCreationRequestCode_to_Status_code: [
                            'Succeeded'
                          ]
                        }
                        expression: {
                          and: [
                            {
                              equals: [
                                '@variables(\'TeamCreationRequestCode\')'
                                '@string(404)'
                              ]
                            }
                          ]
                        }
                        type: 'If'
                      }
                    }
                    runAfter: {}
                    expression: '@equals(variables(\'TeamCreationRequestCode\'), string(202))'
                    limit: {
                      count: 60
                      timeout: 'PT1H'
                    }
                    type: 'Until'
                  }
                  Until_Team_upgrade_succeeded: {
                    actions: {
                      Condition_TeamsCreationStatus_not_succeeded: {
                        actions: {
                          Delay_10_seconds_for_team_upgrade: {
                            runAfter: {}
                            type: 'Wait'
                            inputs: {
                              interval: {
                                count: 10
                                unit: 'Second'
                              }
                            }
                          }
                        }
                        runAfter: {
                          Set_TeamsCreationStatus: [
                            'Succeeded'
                          ]
                        }
                        expression: {
                          and: [
                            {
                              not: {
                                equals: [
                                  '@variables(\'TeamCreationStatus\')'
                                  'succeeded'
                                ]
                              }
                            }
                          ]
                        }
                        type: 'If'
                      }
                      HTTP_get_team_creation_status: {
                        runAfter: {}
                        type: 'Http'
                        inputs: {
                          authentication: {
                            audience: 'https://graph.microsoft.com'
                            identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_ProvisionGenie_ManagedIdentity_name)
                            type: 'ManagedServiceIdentity'
                          }
                          method: 'GET'
                          uri: 'https://graph.microsoft.com/v1.0@{outputs(\'HTTP_update_group_to_team\')[\'headers\'][\'location\']}'
                        }
                      }
                      Set_TeamsCreationStatus: {
                        runAfter: {
                          HTTP_get_team_creation_status: [
                            'Succeeded'
                          ]
                        }
                        type: 'SetVariable'
                        inputs: {
                          name: 'TeamCreationStatus'
                          value: '@{body(\'HTTP_get_team_creation_status\')[\'status\']}'
                        }
                      }
                    }
                    runAfter: {
                      Until_Team_upgrade_accepted: [
                        'Succeeded'
                      ]
                    }
                    expression: '@equals(variables(\'TeamCreationStatus\'), \'succeeded\')'
                    limit: {
                      count: 60
                      timeout: 'PT1H'
                    }
                    type: 'Until'
                  }
                }
              }
              expression: {
                and: [
                  {
                    equals: [
                      '@outputs(\'HTTP_Get_Team\')[\'statusCode\']'
                      200
                    ]
                  }
                ]
              }
              type: 'If'
            }
            HTTP_Get_Team: {
              runAfter: {}
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
                uri: 'https://graph.microsoft.com/v1.0/teams/@{variables(\'TeamGroupId\')}'
              }
            }
          }
          runAfter: {
            Ensure_Group_Exists: [
              'Succeeded'
            ]
          }
          type: 'Scope'
        }
        Initialize_ChannelInfo: {
          runAfter: {
            Initialize_TeamGroupId: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'ChannelInfo'
                type: 'array'
              }
            ]
          }
        }
        Initialize_TeamCreationRequestCode: {
          runAfter: {}
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'TeamCreationRequestCode'
                type: 'string'
              }
            ]
          }
        }
        Initialize_TeamCreationStatus: {
          runAfter: {
            Initialize_TeamCreationRequestCode: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'TeamCreationStatus'
                type: 'string'
              }
            ]
          }
        }
        Initialize_TeamGroupId: {
          runAfter: {
            Initialize_TeamCreationStatus: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'TeamGroupId'
                type: 'string'
              }
            ]
          }
        }
        Response: {
          runAfter: {
            Configure_Channels: [
              'Succeeded'
            ]
          }
          type: 'Response'
          kind: 'Http'
          inputs: {
            body: {
              ChannelInfo: '@variables(\'ChannelInfo\')'
              TeamId: '@{variables(\'TeamGroupId\')}'
              TeamsDisplayName: '@{triggerBody()?[\'Display Name\']}'
            }
            statusCode: 200
          }
        }
      }
      outputs: {}
    }
    parameters: {}
  }
}
