param workflows_ProvisionGenie_Main_name string
param workflows_ProvisionGenie_AddPeople_name string
param workflows_ProvisionGenie_AddNotebook_name string
param workflows_ProvisionGenie_Welcome_name string
param workflows_ProvisionGenie_CreateTaskList_name string
param workflows_ProvisionGenie_CreateListLibrary_name string
param workflows_ProvisionGenie_PinTabToChannel_name string
param workflows_ProvisionGenie_CreateTeam_name string
param userAssignedIdentities_ProvisionGenie_ManagedIdentity_name string
param connections_commondataservice_name string
param resourceLocation string
param DataverseEnvironmentId string

resource workflows_ProvisionGenie_Main_name_resource 'Microsoft.Logic/workflows@2019-05-01' = {
  name: workflows_ProvisionGenie_Main_name
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
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
        DataverseEnvironmentId: {
          defaultValue: DataverseEnvironmentId
          type: 'String'
        }
      }
      triggers: {
        When_a_record_is_created: {
          type: 'ApiConnectionWebhook'
          inputs: {
            body: {
              NotificationUrl: '@{listCallbackUrl()}'
            }
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
              }
            }
            path: '/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'cy_teamsrequests\'))}/onnewitemswebhook'
            queries: {
              scope: 'Organization'
            }
          }
        }
      }
      actions: {
        Channels: {
          runAfter: {
            Complete_Technical_Name_in_Teams_request: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'Channels'
                type: 'array'
              }
            ]
          }
        }
        Complete_Technical_Name_in_Teams_request: {
          runAfter: {
            Generate_Team_internal_name: [
              'Succeeded'
            ]
          }
          type: 'ApiConnection'
          inputs: {
            body: {
              '_ownerid_type': ''
              cy_teamtechnicalname: '@{outputs(\'Generate_Team_internal_name\')}'
            }
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
              }
            }
            method: 'patch'
            path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'cy_teamsrequests\'))}/items/@{encodeURIComponent(encodeURIComponent(triggerBody()?[\'cy_teamsrequestid\']))}'
          }
        }
        Condition_Include_Notebook: {
          actions: {
            'ProvisionGenie-AddNotebook': {
              runAfter: {}
              type: 'Workflow'
              inputs: {
                body: {
                  teamId: '@body(\'Parse_HTTP_body_for_Team_Id\')?[\'TeamId\']'
                  teamName: '@triggerBody()?[\'cy_teamname\']'
                  teamsTechnicalName: '@body(\'Complete_Technical_Name_in_Teams_request\')?[\'cy_teamtechnicalname\']'
                }
                host: {
                  triggerName: 'manual'
                  workflow: {
                    id: resourceId('Microsoft.Logic/workflows', workflows_ProvisionGenie_AddNotebook_name)
                  }
                }
              }
            }
          }
          runAfter: {
            Condition_Include_welcome_package: [
              'Succeeded'
            ]
          }
          expression: {
            and: [
              {
                equals: [
                  '@body(\'Complete_Technical_Name_in_Teams_request\')?[\'pg_includenotebook\']'
                  '@true'
                ]
              }
            ]
          }
          type: 'If'
        }
        Condition_Include_welcome_package: {
          actions: {
            'ProvisionGenie-Welcome': {
              runAfter: {}
              type: 'Workflow'
              inputs: {
                body: {
                  Owner: '@triggerBody()?[\'cy_teamowner\']'
                  TeamId: '@body(\'Parse_HTTP_body_for_Team_Id\')?[\'TeamId\']'
                }
                host: {
                  triggerName: 'manual'
                  workflow: {
                    id: resourceId('Microsoft.Logic/workflows', workflows_ProvisionGenie_Welcome_name)
                  }
                }
              }
            }
          }
          runAfter: {
            Condition_include_task_list: [
              'Succeeded'
            ]
          }
          expression: {
            and: [
              {
                equals: [
                  '@triggerBody()?[\'cy_includewelcomepackage\']'
                  '@true'
                ]
              }
            ]
          }
          type: 'If'
        }
        Condition_include_task_list: {
          actions: {
            'ProvisionGenie-CreateTaskList': {
              runAfter: {}
              type: 'Workflow'
              inputs: {
                body: {
                  siteId: '@{outputs(\'Compose_id\')}'
                }
                host: {
                  triggerName: 'manual'
                  workflow: {
                    id: resourceId('Microsoft.Logic/workflows', workflows_ProvisionGenie_CreateTaskList_name)
                  }
                }
              }
            }
          }
          runAfter: {
            Scope_Add_People: [
              'Succeeded'
            ]
          }
          expression: {
            and: [
              {
                equals: [
                  '@triggerBody()?[\'cy_includetasklist\']'
                  '@true'
                ]
              }
            ]
          }
          type: 'If'
        }
        DriveExistsCode: {
          runAfter: {
            Channels: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'DriveExistsCode'
                type: 'integer'
              }
            ]
          }
        }
        Generate_Team_internal_name: {
          runAfter: {}
          type: 'Compose'
          inputs: '@{replace(triggerBody()?[\'cy_teamname\'],\' \',\'\')}_@{guid()}'
        }
        Guests: {
          runAfter: {
            Owners: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'Guests'
                type: 'array'
              }
            ]
          }
        }
        LibraryColumns: {
          runAfter: {
            SiteExistsCode: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'LibraryColumns'
                type: 'array'
              }
            ]
          }
        }
        ListColumns: {
          runAfter: {
            LibraryColumns: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'ListColumns'
                type: 'array'
              }
            ]
          }
        }
        Members: {
          runAfter: {
            ListColumns: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'Members'
                type: 'array'
              }
            ]
          }
        }
        Owners: {
          runAfter: {
            Members: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'Owners'
                type: 'array'
              }
            ]
          }
        }
        Scope_Add_People: {
          actions: {
            Condition: {
              actions: {
                'ProvisionGenie-AddPeople': {
                  runAfter: {}
                  type: 'Workflow'
                  inputs: {
                    body: {
                      guests: '@variables(\'Guests\')'
                      members: '@variables(\'Members\')'
                      owners: '@variables(\'Owners\')'
                      teamId: '@body(\'Parse_HTTP_body_for_Team_Id\')?[\'TeamId\']'
                      teamName: '@body(\'Complete_Technical_Name_in_Teams_request\')?[\'cy_teamtechnicalname\']'
                    }
                    host: {
                      triggerName: 'manual'
                      workflow: {
                        id: resourceId('Microsoft.Logic/workflows', workflows_ProvisionGenie_AddPeople_name)
                      }
                    }
                  }
                }
              }
              runAfter: {
                For_each_owner: [
                  'Succeeded'
                ]
              }
              expression: {
                or: [
                  {
                    greater: [
                      '@length(variables(\'Members\'))'
                      0
                    ]
                  }
                  {
                    greater: [
                      '@length(variables(\'Owners\'))'
                      0
                    ]
                  }
                  {
                    greater: [
                      '@length(variables(\'Guests\'))'
                      0
                    ]
                  }
                ]
              }
              type: 'If'
            }
            For_each_guest: {
              foreach: '@body(\'List_rows_for_guests\')?[\'value\']'
              actions: {
                Append_to_array_variable_3: {
                  runAfter: {
                    Get_row_3: [
                      'Succeeded'
                    ]
                  }
                  type: 'AppendToArrayVariable'
                  inputs: {
                    name: 'Guests'
                    value: {
                      Organization: '@{body(\'Get_row_3\')?[\'pg_guestorganization\']}'
                      UPN: '@{body(\'Get_row_3\')?[\'pg_name\']}'
                      firstName: '@{body(\'Get_row_3\')?[\'pg_firstname\']}'
                      lastName: '@{body(\'Get_row_3\')?[\'pg_lastname\']}'
                    }
                  }
                }
                Get_row_3: {
                  runAfter: {}
                  type: 'ApiConnection'
                  inputs: {
                    host: {
                      connection: {
                        name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                      }
                    }
                    method: 'get'
                    path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'pg_teamsusers\'))}/items/@{encodeURIComponent(encodeURIComponent(items(\'For_each_guest\')?[\'pg_teamsuserid\']))}'
                  }
                }
              }
              runAfter: {
                List_rows_for_guests: [
                  'Succeeded'
                ]
              }
              type: 'Foreach'
            }
            For_each_member: {
              foreach: '@body(\'List_rows_for_members\')?[\'value\']'
              actions: {
                Append_to_array_variable: {
                  runAfter: {
                    Get_row: [
                      'Succeeded'
                    ]
                  }
                  type: 'AppendToArrayVariable'
                  inputs: {
                    name: 'Members'
                    value: '@body(\'Get_row\')?[\'pg_name\']'
                  }
                }
                Get_row: {
                  runAfter: {}
                  type: 'ApiConnection'
                  inputs: {
                    host: {
                      connection: {
                        name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                      }
                    }
                    method: 'get'
                    path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'pg_teamsusers\'))}/items/@{encodeURIComponent(encodeURIComponent(items(\'For_each_member\')?[\'pg_teamsuserid\']))}'
                  }
                }
              }
              runAfter: {
                List_rows_for_members: [
                  'Succeeded'
                ]
              }
              type: 'Foreach'
            }
            For_each_owner: {
              foreach: '@body(\'List_rows_owner\')?[\'value\']'
              actions: {
                Append_to_array_variable_2: {
                  runAfter: {
                    Get_row_2: [
                      'Succeeded'
                    ]
                  }
                  type: 'AppendToArrayVariable'
                  inputs: {
                    name: 'Owners'
                    value: '@body(\'Get_row_2\')?[\'pg_name\']'
                  }
                }
                Get_row_2: {
                  runAfter: {}
                  type: 'ApiConnection'
                  inputs: {
                    host: {
                      connection: {
                        name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                      }
                    }
                    method: 'get'
                    path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'pg_teamsusers\'))}/items/@{encodeURIComponent(encodeURIComponent(items(\'For_each_owner\')?[\'pg_teamsuserid\']))}'
                  }
                }
              }
              runAfter: {
                List_rows_owner: [
                  'Succeeded'
                ]
              }
              type: 'Foreach'
            }
            List_rows_for_guests: {
              runAfter: {
                For_each_member: [
                  'Succeeded'
                ]
              }
              type: 'ApiConnection'
              inputs: {
                host: {
                  connection: {
                    name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                  }
                }
                method: 'get'
                path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'pg_teamsuser_teamsrequest_guestsset\'))}/items'
                queries: {
                  '$filter': 'cy_teamsrequestid eq \'@{triggerBody()?[\'cy_teamsrequestid\']}\' '
                }
              }
            }
            List_rows_for_members: {
              runAfter: {}
              type: 'ApiConnection'
              inputs: {
                host: {
                  connection: {
                    name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                  }
                }
                method: 'get'
                path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'pg_teamsuser_teamsrequest_membersset\'))}/items'
                queries: {
                  '$filter': 'cy_teamsrequestid eq \'@{triggerBody()?[\'cy_teamsrequestid\']}\' '
                }
              }
            }
            List_rows_owner: {
              runAfter: {
                For_each_guest: [
                  'Succeeded'
                ]
              }
              type: 'ApiConnection'
              inputs: {
                host: {
                  connection: {
                    name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                  }
                }
                method: 'get'
                path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'pg_teamsuser_teamsrequest_ownersset\'))}/items'
                queries: {
                  '$filter': 'cy_teamsrequestid eq \'@{triggerBody()?[\'cy_teamsrequestid\']}\''
                }
              }
            }
          }
          runAfter: {
            Scope_Create_Lists_and_Libraries: [
              'Succeeded'
            ]
          }
          type: 'Scope'
        }
        Scope_Create_Lists_and_Libraries: {
          actions: {
            For_each_SharePoint_Library_record: {
              foreach: '@body(\'List_related_SharePoint_Library_records\')?[\'value\']'
              actions: {
                Condition_Library_is_linked_to_Channel: {
                  actions: {
                    Get_Channel_for_Library: {
                      runAfter: {}
                      type: 'ApiConnection'
                      inputs: {
                        host: {
                          connection: {
                            name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                          }
                        }
                        method: 'get'
                        path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'cy_teamchannels\'))}/items/@{encodeURIComponent(encodeURIComponent(items(\'For_each_SharePoint_Library_record\')?[\'_pg_channel_value\']))}'
                      }
                    }
                    'ProvisionGenie-PinTabToChannel_for_Library': {
                      runAfter: {
                        Get_Channel_for_Library: [
                          'Succeeded'
                        ]
                      }
                      type: 'Workflow'
                      inputs: {
                        body: {
                          channelId: '@body(\'Get_Channel_for_Library\')?[\'pg_channelid\']'
                          tabName: '@items(\'For_each_SharePoint_Library_record\')?[\'cy_libraryname\']'
                          tabType: 'Library'
                          tabUrl: '@{body(\'ProvisionGenie-CreateListLibrary_for_Library\')[\'webUrl\']}'
                          teamId: '@body(\'Parse_HTTP_body_for_Team_Id\')?[\'TeamId\']'
                        }
                        host: {
                          triggerName: 'manual'
                          workflow: {
                         id: resourceId('Microsoft.Logic/workflows', workflows_ProvisionGenie_PinTabToChannel_name)
                          }
                        }
                      }
                    }
                  }
                  runAfter: {
                    'ProvisionGenie-CreateListLibrary_for_Library': [
                      'Succeeded'
                    ]
                  }
                  expression: {
                    and: [
                      {
                        not: {
                          equals: [
                            '@items(\'For_each_SharePoint_Library_record\')?[\'_pg_channel_value\']'
                            null
                          ]
                        }
                      }
                    ]
                  }
                  type: 'If'
                }
                For_each_Library_Column_record: {
                  foreach: '@body(\'List_related_Library_Column_records\')?[\'value\']'
                  actions: {
                    Append_column_definition_to_LibraryColumns: {
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                      inputs: {
                        name: 'LibraryColumns'
                        value: {
                          columnName: '@{items(\'For_each_Library_Column_record\')?[\'cy_columnname\']}'
                          columnType: '@{items(\'For_each_Library_Column_record\')?[\'_cy_columntype_label\']}'
                          columnvalues: '@if(equals(items(\'For_each_Library_Column_record\')?[\'_cy_columntype_label\'],\'Choice\'),array(split(items(\'For_each_Library_Column_record\')?[\'cy_columnvalues\'],\',\')),null)'
                        }
                      }
                    }
                  }
                  runAfter: {
                    List_related_Library_Column_records: [
                      'Succeeded'
                    ]
                  }
                  type: 'Foreach'
                  description: 'Append column information to LibraryColumns variable'
                }
                List_related_Library_Column_records: {
                  runAfter: {}
                  type: 'ApiConnection'
                  inputs: {
                    host: {
                      connection: {
                        name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                      }
                    }
                    method: 'get'
                    path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'cy_listcolumns\'))}/items'
                    queries: {
                      '$filter': '_cy_sharepointlibrary_value eq \'@{items(\'For_each_SharePoint_Library_record\')?[\'cy_sharepointlibraryid\']}\''
                    }
                  }
                  description: 'Get the columns related to this library record'
                }
                'ProvisionGenie-CreateListLibrary_for_Library': {
                  runAfter: {
                    For_each_Library_Column_record: [
                      'Succeeded'
                    ]
                  }
                  type: 'Workflow'
                  inputs: {
                    body: {
                      columns: '@variables(\'LibraryColumns\')'
                      resourceName: '@items(\'For_each_SharePoint_Library_record\')?[\'cy_libraryname\']'
                      resourceType: 'Library'
                      siteId: '@{outputs(\'Compose_id\')}'
                    }
                    host: {
                      triggerName: 'manual'
                      workflow: {
                        id: resourceId('Microsoft.Logic/workflows', workflows_ProvisionGenie_CreateListLibrary_name)
                      }
                    }
                  }
                }
              }
              runAfter: {
                List_related_SharePoint_Library_records: [
                  'Succeeded'
                ]
              }
              type: 'Foreach'
              description: 'Get column information and call child logic app to create the library'
              runtimeConfiguration: {
                concurrency: {
                  repetitions: 1
                }
              }
            }
            For_each_SharePoint_List_record: {
              foreach: '@body(\'List_related_SharePoint_List_records\')?[\'value\']'
              actions: {
                Condition_List_is_linked_to_Channel: {
                  actions: {
                    Get_Channel_for_List: {
                      runAfter: {}
                      type: 'ApiConnection'
                      inputs: {
                        host: {
                          connection: {
                            name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                          }
                        }
                        method: 'get'
                        path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'cy_teamchannels\'))}/items/@{encodeURIComponent(encodeURIComponent(items(\'For_each_SharePoint_List_record\')?[\'_pg_channel_value\']))}'
                      }
                    }
                    'ProvisionGenie-PinTabToChannel_for_List': {
                      runAfter: {
                        Get_Channel_for_List: [
                          'Succeeded'
                        ]
                      }
                      type: 'Workflow'
                      inputs: {
                        body: {
                          channelId: '@body(\'Get_Channel_for_List\')?[\'pg_channelid\']'
                          tabName: '@items(\'For_each_SharePoint_List_record\')?[\'cy_listname\']'
                          tabType: 'List'
                          tabUrl: '@{body(\'ProvisionGenie-CreateListLibrary_for_List\')[\'webUrl\']}'
                          teamId: '@body(\'Parse_HTTP_body_for_Team_Id\')?[\'TeamId\']'
                        }
                        host: {
                          triggerName: 'manual'
                          workflow: {
                            id: resourceId('Microsoft.Logic/workflows', workflows_ProvisionGenie_PinTabToChannel_name)
                          }
                        }
                      }
                    }
                  }
                  runAfter: {
                    'ProvisionGenie-CreateListLibrary_for_List': [
                      'Succeeded'
                    ]
                  }
                  expression: {
                    and: [
                      {
                        not: {
                          equals: [
                            '@items(\'For_each_SharePoint_List_record\')?[\'_pg_channel_value\']'
                            null
                          ]
                        }
                      }
                    ]
                  }
                  type: 'If'
                }
                For_each_List_Column_record: {
                  foreach: '@body(\'List_related_List_Column_records\')?[\'value\']'
                  actions: {
                    Append_column_definition_to_ListColumns: {
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                      inputs: {
                        name: 'ListColumns'
                        value: {
                          columnName: '@{items(\'For_each_List_Column_record\')?[\'cy_columnname\']}'
                          columnType: '@{items(\'For_each_List_Column_record\')?[\'_cy_columntype_label\']}'
                          columnvalues: '@if(equals(items(\'For_each_List_Column_record\')?[\'_cy_columntype_label\'],\'Choice\'),array(split(items(\'For_each_List_Column_record\')?[\'cy_columnvalues\'],\',\')),null)'
                        }
                      }
                    }
                  }
                  runAfter: {
                    List_related_List_Column_records: [
                      'Succeeded'
                    ]
                  }
                  type: 'Foreach'
                  description: 'Append column information to ListColumn variable'
                }
                List_related_List_Column_records: {
                  runAfter: {}
                  type: 'ApiConnection'
                  inputs: {
                    host: {
                      connection: {
                        name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                      }
                    }
                    method: 'get'
                    path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'cy_listcolumns\'))}/items'
                    queries: {
                      '$filter': '_cy_sharepointlist_value eq \'@{items(\'For_each_SharePoint_List_record\')?[\'cy_sharepointlistid\']}\''
                    }
                  }
                  description: 'Get the columns in this list record'
                }
                'ProvisionGenie-CreateListLibrary_for_List': {
                  runAfter: {
                    For_each_List_Column_record: [
                      'Succeeded'
                    ]
                  }
                  type: 'Workflow'
                  inputs: {
                    body: {
                      columns: '@variables(\'ListColumns\')'
                      resourceName: '@items(\'For_each_SharePoint_List_record\')?[\'cy_listname\']'
                      resourceType: 'List'
                      siteId: '@{outputs(\'Compose_id\')}'
                    }
                    host: {
                      triggerName: 'manual'
                      workflow: {
                        id: resourceId('Microsoft.Logic/workflows', workflows_ProvisionGenie_CreateListLibrary_name)
                      }
                    }
                  }
                }
              }
              runAfter: {
                List_related_SharePoint_List_records: [
                  'Succeeded'
                ]
              }
              type: 'Foreach'
              description: 'Get column information and call child logic app to create the list'
              runtimeConfiguration: {
                concurrency: {
                  repetitions: 1
                }
              }
            }
            List_related_SharePoint_Library_records: {
              runAfter: {
                For_each_SharePoint_List_record: [
                  'Succeeded'
                ]
              }
              type: 'ApiConnection'
              inputs: {
                host: {
                  connection: {
                    name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                  }
                }
                method: 'get'
                path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'cy_sharepointlibraries\'))}/items'
                queries: {
                  '$filter': '_cy_teamsrequest_value eq \'@{triggerBody()?[\'cy_teamsrequestid\']}\''
                }
              }
              description: 'Get SharePoint Library records related to the Teams request'
            }
            List_related_SharePoint_List_records: {
              runAfter: {}
              type: 'ApiConnection'
              inputs: {
                host: {
                  connection: {
                    name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                  }
                }
                method: 'get'
                path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'cy_sharepointlists\'))}/items'
                queries: {
                  '$filter': '_cy_teamsrequest_value eq \'@{triggerBody()?[\'cy_teamsrequestid\']}\''
                }
              }
              description: 'Get SharePoint List records related to the Teams request'
            }
          }
          runAfter: {
            Scope_Create_Team: [
              'Succeeded'
            ]
          }
          type: 'Scope'
        }
        Scope_Create_Team: {
          actions: {
            Compose_files_folder_path: {
              runAfter: {
                Until_drive_exists: [
                  'Succeeded'
                ]
              }
              type: 'Compose'
              inputs: '@replace(body(\'HTTP_to_check_if_root_drive_exists\')[\'webUrl\'],body(\'Get_Team_root_site\')[\'webUrl\'],\'\')'
            }
            For_each_created_Channel: {
              foreach: '@body(\'Parse_HTTP_body_for_Team_Id\')?[\'ChannelInfo\']'
              actions: {
                Condition_Channel_present: {
                  actions: {
                    Add_Id_for_Channel: {
                      runAfter: {}
                      type: 'ApiConnection'
                      inputs: {
                        body: {
                          '_ownerid_type': ''
                          pg_channelid: '@items(\'For_each_created_Channel\')?[\'Id\']'
                        }
                        host: {
                          connection: {
                            name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                          }
                        }
                        method: 'patch'
                        path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'cy_teamchannels\'))}/items/@{encodeURIComponent(encodeURIComponent(first(body(\'Get_Channel_Info\')?[\'value\'])?[\'cy_teamchannelid\']))}'
                      }
                    }
                  }
                  runAfter: {
                    Get_Channel_Info: [
                      'Succeeded'
                    ]
                  }
                  else: {
                    actions: {
                      Add_Id_for_General_Channel: {
                        runAfter: {
                          Get_General_Channel: [
                            'Succeeded'
                          ]
                        }
                        type: 'ApiConnection'
                        inputs: {
                          body: {
                            '_ownerid_type': ''
                            pg_channelid: '@items(\'For_each_created_Channel\')?[\'Id\']'
                          }
                          host: {
                            connection: {
                              name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                            }
                          }
                          method: 'patch'
                          path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'cy_teamchannels\'))}/items/@{encodeURIComponent(encodeURIComponent(first(body(\'Get_General_Channel\')?[\'value\'])?[\'cy_teamchannelid\']))}'
                        }
                      }
                      Get_General_Channel: {
                        runAfter: {}
                        type: 'ApiConnection'
                        inputs: {
                          host: {
                            connection: {
                              name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                            }
                          }
                          method: 'get'
                          path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'cy_teamchannels\'))}/items'
                          queries: {
                            '$filter': '_cy_teamsrequest_value eq \'@{triggerBody()?[\'cy_teamsrequestid\']}\' and cy_channelname eq \'General\''
                          }
                        }
                        description: 'Will only run for other languages (when General channel has a different name, e.g. Algemeen)'
                      }
                    }
                  }
                  expression: {
                    and: [
                      {
                        greater: [
                          '@length(body(\'Get_Channel_Info\')?[\'value\'])'
                          0
                        ]
                      }
                    ]
                  }
                  type: 'If'
                }
                Get_Channel_Info: {
                  runAfter: {}
                  type: 'ApiConnection'
                  inputs: {
                    host: {
                      connection: {
                        name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                      }
                    }
                    method: 'get'
                    path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'cy_teamchannels\'))}/items'
                    queries: {
                      '$filter': '_cy_teamsrequest_value eq \'@{triggerBody()?[\'cy_teamsrequestid\']}\' and cy_channelname eq \'@{items(\'For_each_created_Channel\')?[\'Name\']}\''
                    }
                  }
                }
              }
              runAfter: {
                Parse_HTTP_body_for_Team_Id: [
                  'Succeeded'
                ]
              }
              type: 'Foreach'
            }
            For_each_related_Channel: {
              foreach: '@body(\'List_related_Team_Channel_records\')?[\'value\']'
              actions: {
                Append_to_Channels: {
                  runAfter: {}
                  type: 'AppendToArrayVariable'
                  inputs: {
                    name: 'Channels'
                    value: {
                      description: '@{items(\'For_each_related_Channel\')?[\'cy_channeldescription\']}'
                      displayName: '@{items(\'For_each_related_Channel\')?[\'cy_channelname\']}'
                      isFavoriteByDefault: '@items(\'For_each_related_Channel\')?[\'cy_autofavorite\']'
                    }
                  }
                }
              }
              runAfter: {
                List_related_Team_Channel_records: [
                  'Succeeded'
                ]
              }
              type: 'Foreach'
              description: 'Append channel information to Channels variable'
            }
            List_related_Team_Channel_records: {
              runAfter: {}
              type: 'ApiConnection'
              inputs: {
                host: {
                  connection: {
                    name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                  }
                }
                method: 'get'
                path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'cy_teamchannels\'))}/items'
                queries: {
                  '$filter': '_cy_teamsrequest_value eq \'@{triggerBody()?[\'cy_teamsrequestid\']}\' and cy_channelname ne \'General\''
                }
              }
              description: 'Get the channels related to the trigger\'s Teams request'
            }
            Parse_HTTP_body_for_Team_Id: {
              runAfter: {
                'ProvisionGenie-CreateTeam': [
                  'Succeeded'
                ]
              }
              type: 'ParseJson'
              inputs: {
                content: '@body(\'ProvisionGenie-CreateTeam\')'
                schema: {
                  properties: {
                    ChannelInfo: {
                      items: {
                        properties: {
                          Id: {
                            type: 'string'
                          }
                          Name: {
                            type: 'string'
                          }
                        }
                        required: [
                          'Id'
                          'Name'
                        ]
                        type: 'object'
                      }
                      type: 'array'
                    }
                    TeamId: {
                      type: 'string'
                    }
                    TeamsDisplayName: {
                      type: 'string'
                    }
                  }
                  type: 'object'
                }
              }
            }
            'ProvisionGenie-CreateTeam': {
              runAfter: {
                For_each_related_Channel: [
                  'Succeeded'
                ]
              }
              type: 'Workflow'
              inputs: {
                body: {
                  Channels: '@variables(\'Channels\')'
                  Description: '@triggerBody()?[\'cy_teamdescription\']'
                  'Display Name': '@triggerBody()?[\'cy_teamname\']'
                  'Owner UPN': '@triggerBody()?[\'cy_teamowner\']'
                  'Technical Name': '@{outputs(\'Generate_Team_internal_name\')}'
                }
                host: {
                  triggerName: 'manual'
                  workflow: {
                    id: resourceId('Microsoft.Logic/workflows', workflows_ProvisionGenie_CreateTeam_name)
                  }
                }
              }
            }
            Until_drive_exists: {
              actions: {
                Condition_DriveExistsCode_200: {
                  actions: {}
                  runAfter: {
                    Update_DriveExistsCode: [
                      'Succeeded'
                    ]
                  }
                  else: {
                    actions: {
                      Delay_2: {
                        runAfter: {}
                        type: 'Wait'
                        inputs: {
                          interval: {
                            count: 30
                            unit: 'Second'
                          }
                        }
                      }
                    }
                  }
                  expression: {
                    and: [
                      {
                        equals: [
                          '@variables(\'DriveExistsCode\')'
                          200
                        ]
                      }
                    ]
                  }
                  type: 'If'
                }
                HTTP_to_check_if_root_drive_exists: {
                  runAfter: {}
                  type: 'Http'
                  inputs: {
                    authentication: {
                      audience: 'https://graph.microsoft.com'
                      identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_ProvisionGenie_ManagedIdentity_name)
                      type: 'ManagedServiceIdentity'
                    }
                    method: 'GET'
                    uri: 'https://graph.microsoft.com/v1.0/groups/@{body(\'Parse_HTTP_body_for_Team_Id\')?[\'TeamId\']}/drive/root'
                  }
                }
                Update_DriveExistsCode: {
                  runAfter: {
                    HTTP_to_check_if_root_drive_exists: [
                      'Succeeded'
                    ]
                  }
                  type: 'SetVariable'
                  inputs: {
                    name: 'DriveExistsCode'
                    value: '@outputs(\'HTTP_to_check_if_root_drive_exists\')[\'statusCode\']'
                  }
                }
              }
              runAfter: {
                Until_root_site_exists: [
                  'Succeeded'
                ]
              }
              expression: '@equals(variables(\'DriveExistsCode\'), 200)'
              limit: {
                count: 1000
                timeout: 'PT1H'
              }
              type: 'Until'
              description: 'Wait until the folder is created - otherwise following actions will fail'
            }
            Until_root_site_exists: {
              actions: {
                Compose_id: {
                  runAfter: {
                    Compose_webUrl: [
                      'Succeeded'
                    ]
                  }
                  type: 'Compose'
                  inputs: '@outputs(\'Get_Team_root_site\')?[\'body\'][\'id\']'
                }
                Compose_webUrl: {
                  runAfter: {
                    Get_Team_root_site: [
                      'Succeeded'
                    ]
                  }
                  type: 'Compose'
                  inputs: '@outputs(\'Get_Team_root_site\')?[\'body\'][\'webUrl\']'
                }
                Condition_SiteExistsCode_200: {
                  actions: {}
                  runAfter: {
                    Update_SiteExistsCode: [
                      'Succeeded'
                    ]
                  }
                  else: {
                    actions: {
                      Delay: {
                        runAfter: {}
                        type: 'Wait'
                        inputs: {
                          interval: {
                            count: 30
                            unit: 'Second'
                          }
                        }
                      }
                    }
                  }
                  expression: {
                    and: [
                      {
                        equals: [
                          '@variables(\'SiteExistsCode\')'
                          200
                        ]
                      }
                    ]
                  }
                  type: 'If'
                }
                Get_Team_root_site: {
                  runAfter: {}
                  type: 'Http'
                  inputs: {
                    authentication: {
                      audience: 'https://graph.microsoft.com'
                      identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_ProvisionGenie_ManagedIdentity_name)
                      type: 'ManagedServiceIdentity'
                    }
                    method: 'GET'
                    uri: 'https://graph.microsoft.com/v1.0/groups/@{body(\'Parse_HTTP_body_for_Team_Id\')?[\'TeamId\']}/sites/root'
                  }
                }
                Update_SiteExistsCode: {
                  runAfter: {
                    Compose_id: [
                      'Succeeded'
                    ]
                  }
                  type: 'SetVariable'
                  inputs: {
                    name: 'SiteExistsCode'
                    value: '@outputs(\'Get_Team_root_site\')[\'statusCode\']'
                  }
                }
              }
              runAfter: {
                For_each_created_Channel: [
                  'Succeeded'
                ]
              }
              expression: '@equals(variables(\'SiteExistsCode\'), 200)'
              limit: {
                count: 1000
                timeout: 'PT1H'
              }
              type: 'Until'
              description: 'Wait until the root site exists - otherwise following actions will fail'
            }
          }
          runAfter: {
            Wait_1_minute_to_add_channels: [
              'Succeeded'
            ]
          }
          type: 'Scope'
          description: 'Get channel information, create team and wait for team creation to complete'
        }
        SiteExistsCode: {
          runAfter: {
            DriveExistsCode: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'SiteExistsCode'
                type: 'integer'
              }
            ]
          }
        }
        Wait_1_minute_to_add_channels: {
          runAfter: {
            Guests: [
              'Succeeded'
            ]
          }
          type: 'Wait'
          inputs: {
            interval: {
              count: 1
              unit: 'Minute'
            }
          }
          description: 'Wait 1 minute to provide time for the channels to be linked to the team that has been created'
        }
      }
      outputs: {}
    }
parameters: {
      '$connections': {
       value: {
          commondataservice: {
            connectionId: resourceId('Microsoft.Web/connections', connections_commondataservice_name)
            connectionName: 'commondataservice'
            id: '${subscription().id}/providers/Microsoft.Web/locations/${resourceLocation}/managedApis/commondataservice'
          }
        }
      }
    }
  }
}
