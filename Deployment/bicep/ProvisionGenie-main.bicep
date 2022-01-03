param workflows_ProvisionGenie_Main_name string
param workflows_ProvisionGenie_AddPeople_name string
param workflows_ProvisionGenie_Welcome_name string
param workflows_ProvisionGenie_CreateTaskList_name string
param workflows_ProvisionGenie_CreateLibrary_name string
param workflows_ProvisionGenie_CreateList_name string
param workflows_ProvisionGenie_CreateTeam_name string
param userAssignedIdentities_ProvisionGenie_ManagedIdentity_name string
param connections_commondataservice_name string
param resourceLocation string
param DataverseEnvironmentId string
param tenantUrl string

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
      actions: {
        Channels: {
          inputs: {
            variables: [
              {
                name: 'Channels'
                type: 'array'
              }
            ]
          }
          runAfter: {
            Complete_Technical_Name_in_Teams_request: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
        }
        Complete_Technical_Name_in_Teams_request: {
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
          runAfter: {
            Generate_Team_internal_name: [
              'Succeeded'
            ]
          }
          type: 'ApiConnection'
        }
        Condition_Include_welcome_package: {
          actions: {
            'ProvisionGenie-Welcome': {
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
              runAfter: {}
              type: 'Workflow'
            }
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
          runAfter: {
            Condition_include_task_list: [
              'Succeeded'
            ]
          }
          type: 'If'
        }
        Condition_include_task_list: {
          actions: {
            'ProvisionGenie-CreateTaskList': {
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
              runAfter: {}
              type: 'Workflow'
            }
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
          runAfter: {
            Scope_Add_People: [
              'Succeeded'
            ]
          }
          type: 'If'
        }
        DriveExistsCode: {
          inputs: {
            variables: [
              {
                name: 'DriveExistsCode'
                type: 'integer'
              }
            ]
          }
          runAfter: {
            Channels: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
        }
        Generate_Team_internal_name: {
          inputs: '@{replace(triggerBody()?[\'cy_teamname\'],\' \',\'\')}_@{guid()}'
          runAfter: {}
          type: 'Compose'
        }
        LibraryColumns: {
          inputs: {
            variables: [
              {
                name: 'LibraryColumns'
                type: 'array'
              }
            ]
          }
          runAfter: {
            SiteExistsCode: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
        }
        ListColumns: {
          inputs: {
            variables: [
              {
                name: 'ListColumns'
                type: 'array'
              }
            ]
          }
          runAfter: {
            LibraryColumns: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
        }
        Members: {
          inputs: {
            variables: [
              {
                name: 'Members'
                type: 'string'
              }
            ]
          }
          runAfter: {
            ListColumns: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
        }
        Owners: {
          inputs: {
            variables: [
              {
                name: 'Owners'
                type: 'string'
              }
            ]
          }
          runAfter: {
            Members: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
        }
        Scope_Add_People: {
          actions: {
            Condition: {
              actions: {
                'ProvisionGenie-AddPeople': {
                  inputs: {
                    body: {
                      members: '@{substring(variables(\'Members\'),0,sub(length(variables(\'Members\')),1))}'
                      owners: '@{substring(variables(\'Owners\'),0,sub(length(variables(\'Owners\')),1))}'
                      teamId: '@body(\'Parse_HTTP_body_for_Team_Id\')?[\'TeamId\']'
                    }
                    host: {
                      triggerName: 'manual'
                      workflow: {
                        id: resourceId('Microsoft.Logic/workflows', workflows_ProvisionGenie_AddPeople_name)
                      }
                    }
                  }
                  runAfter: {}
                  type: 'Workflow'
                }
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
                ]
              }
              runAfter: {
                For_each_owner: [
                  'Succeeded'
                ]
              }
              type: 'If'
            }
            For_each_member: {
              actions: {
                Append_to_string_variable: {
                  inputs: {
                    name: 'Members'
                    value: '@{body(\'Get_row\')?[\'pg_name\']};'
                  }
                  runAfter: {
                    Get_row: [
                      'Succeeded'
                    ]
                  }
                  type: 'AppendToStringVariable'
                }
                Get_row: {
                  inputs: {
                    host: {
                      connection: {
                        name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                      }
                    }
                    method: 'get'
                    path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'pg_teamsusers\'))}/items/@{encodeURIComponent(encodeURIComponent(items(\'For_each_member\')?[\'pg_teamsuserid\']))}'
                  }
                  runAfter: {}
                  type: 'ApiConnection'
                }
              }
              foreach: '@body(\'List_rows_for_members\')?[\'value\']'
              runAfter: {
                List_rows_for_members: [
                  'Succeeded'
                ]
              }
              type: 'Foreach'
            }
            For_each_owner: {
              actions: {
                Append_to_string_variable_2: {
                  inputs: {
                    name: 'Owners'
                    value: '@{body(\'Get_row_2\')?[\'pg_name\']};'
                  }
                  runAfter: {
                    Get_row_2: [
                      'Succeeded'
                    ]
                  }
                  type: 'AppendToStringVariable'
                }
                Get_row_2: {
                  inputs: {
                    host: {
                      connection: {
                        name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                      }
                    }
                    method: 'get'
                    path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'pg_teamsusers\'))}/items/@{encodeURIComponent(encodeURIComponent(items(\'For_each_owner\')?[\'pg_teamsuserid\']))}'
                  }
                  runAfter: {}
                  type: 'ApiConnection'
                }
              }
              foreach: '@body(\'List_rows_owner\')?[\'value\']'
              runAfter: {
                List_rows_owner: [
                  'Succeeded'
                ]
              }
              type: 'Foreach'
            }
            List_rows_for_members: {
              inputs: {
                host: {
                  connection: {
                    name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                  }
                }
                method: 'get'
                path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'pg_teamsuser_teamsrequest_membersset\'))}/items'
                queries: {
                  '$filter': 'cy_teamsrequestid eq \'@{triggerBody()?[\'cy_teamsrequestid\']}\''
                }
              }
              runAfter: {}
              type: 'ApiConnection'
            }
            List_rows_owner: {
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
              runAfter: {
                For_each_member: [
                  'Succeeded'
                ]
              }
              type: 'ApiConnection'
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
              actions: {
                For_each_Library_Column_record: {
                  actions: {
                    Append_column_definition_to_LibraryColumns: {
                      inputs: {
                        name: 'LibraryColumns'
                        value: {
                          columnName: '@{items(\'For_each_Library_Column_record\')?[\'cy_columnname\']}'
                          columnType: '@{items(\'For_each_Library_Column_record\')?[\'_cy_columntype_label\']}'
                          columnvalues: '@if(equals(items(\'For_each_Library_Column_record\')?[\'_cy_columntype_label\'],\'Choice\'),array(split(items(\'For_each_Library_Column_record\')?[\'cy_columnvalues\'],\',\')),null)'
                        }
                      }
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                    }
                  }
                  description: 'Append column information to LibraryColumns variable'
                  foreach: '@body(\'List_related_Library_Column_records\')?[\'value\']'
                  runAfter: {
                    List_related_Library_Column_records: [
                      'Succeeded'
                    ]
                  }
                  type: 'Foreach'
                }
                List_related_Library_Column_records: {
                  description: 'Get the columns related to this library record'
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
                  runAfter: {}
                  type: 'ApiConnection'
                }
                'ProvisionGenie-CreateLibrary': {
                  inputs: {
                    body: {
                      libraryColumns: '@variables(\'LibraryColumns\')'
                      libraryName: '@items(\'For_each_SharePoint_Library_record\')?[\'cy_libraryname\']'
                      siteId: '@{outputs(\'Compose_id\')}'
                    }
                    host: {
                      triggerName: 'manual'
                      workflow: {
                        id: resourceId('Microsoft.Logic/workflows', workflows_ProvisionGenie_CreateLibrary_name)
                      }
                    }
                  }
                  runAfter: {
                    For_each_Library_Column_record: [
                      'Succeeded'
                    ]
                  }
                  type: 'Workflow'
                }
              }
              description: 'Get column information and call child logic app to create the library'
              foreach: '@body(\'List_related_SharePoint_Library_records\')?[\'value\']'
              runAfter: {
                List_related_SharePoint_Library_records: [
                  'Succeeded'
                ]
              }
              runtimeConfiguration: {
                concurrency: {
                  repetitions: 1
                }
              }
              type: 'Foreach'
            }
            For_each_SharePoint_List_record: {
              actions: {
                For_each_List_Column_record: {
                  actions: {
                    Append_column_definition_to_ListColumns: {
                      inputs: {
                        name: 'ListColumns'
                        value: {
                          columnName: '@{items(\'For_each_List_Column_record\')?[\'cy_columnname\']}'
                          columnType: '@{items(\'For_each_List_Column_record\')?[\'_cy_columntype_label\']}'
                          columnvalues: '@if(equals(items(\'For_each_List_Column_record\')?[\'_cy_columntype_label\'],\'Choice\'),array(split(items(\'For_each_List_Column_record\')?[\'cy_columnvalues\'],\',\')),null)'
                        }
                      }
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                    }
                  }
                  description: 'Append column information to ListColumn variable'
                  foreach: '@body(\'List_related_List_Column_records\')?[\'value\']'
                  runAfter: {
                    List_related_List_Column_records: [
                      'Succeeded'
                    ]
                  }
                  type: 'Foreach'
                }
                List_related_List_Column_records: {
                  description: 'Get the columns in this list record'
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
                  runAfter: {}
                  type: 'ApiConnection'
                }
                'ProvisionGenie-CreateList': {
                  inputs: {
                    body: {
                      listColumns: '@variables(\'ListColumns\')'
                      listName: '@items(\'For_each_SharePoint_List_record\')?[\'cy_listname\']'
                      siteId: '@{outputs(\'Compose_id\')}'
                    }
                    host: {
                      triggerName: 'manual'
                      workflow: {
                        id: resourceId('Microsoft.Logic/workflows', workflows_ProvisionGenie_CreateList_name)
                      }
                    }
                  }
                  runAfter: {
                    For_each_List_Column_record: [
                      'Succeeded'
                    ]
                  }
                  type: 'Workflow'
                }
              }
              description: 'Get column information and call child logic app to create the list'
              foreach: '@body(\'List_related_SharePoint_List_records\')?[\'value\']'
              runAfter: {
                List_related_SharePoint_List_records: [
                  'Succeeded'
                ]
              }
              runtimeConfiguration: {
                concurrency: {
                  repetitions: 1
                }
              }
              type: 'Foreach'
            }
            List_related_SharePoint_Library_records: {
              description: 'Get SharePoint Library records related to the Teams request'
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
              runAfter: {
                For_each_SharePoint_List_record: [
                  'Succeeded'
                ]
              }
              type: 'ApiConnection'
            }
            List_related_SharePoint_List_records: {
              description: 'Get SharePoint List records related to the Teams request'
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
              runAfter: {}
              type: 'ApiConnection'
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
              inputs: '@replace(body(\'HTTP_to_check_if_root_drive_exists\')[\'webUrl\'],body(\'Get_Team_root_site\')[\'webUrl\'],\'\')'
              runAfter: {
                Until_drive_exists: [
                  'Succeeded'
                ]
              }
              type: 'Compose'
            }
            For_each_related_Channel: {
              actions: {
                Append_to_Channels: {
                  inputs: {
                    name: 'Channels'
                    value: {
                      description: '@{items(\'For_each_related_Channel\')?[\'cy_channeldescription\']}'
                      displayName: '@{items(\'For_each_related_Channel\')?[\'cy_channelname\']}'
                      isFavoriteByDefault: '@items(\'For_each_related_Channel\')?[\'cy_autofavorite\']'
                    }
                  }
                  runAfter: {}
                  type: 'AppendToArrayVariable'
                }
              }
              description: 'Append channel information to Channels variable'
              foreach: '@body(\'List_related_Team_Channel_records\')?[\'value\']'
              runAfter: {
                List_related_Team_Channel_records: [
                  'Succeeded'
                ]
              }
              type: 'Foreach'
            }
            List_related_Team_Channel_records: {
              description: 'Get the channels related to the trigger\'s Teams request'
              inputs: {
                host: {
                  connection: {
                    name: '@parameters(\'$connections\')[\'commondataservice\'][\'connectionId\']'
                  }
                }
                method: 'get'
                path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(parameters(\'DataverseEnvironmentId\')))}/tables/@{encodeURIComponent(encodeURIComponent(\'cy_teamchannels\'))}/items'
                queries: {
                  '$filter': '_cy_teamsrequest_value eq \'@{triggerBody()?[\'cy_teamsrequestid\']}\''
                }
              }
              runAfter: {}
              type: 'ApiConnection'
            }
            Parse_HTTP_body_for_Team_Id: {
              inputs: {
                content: '@body(\'ProvisionGenie-CreateTeam\')'
                schema: {
                  properties: {
                    TeamId: {
                      type: 'string'
                    }
                  }
                  type: 'object'
                }
              }
              runAfter: {
                'ProvisionGenie-CreateTeam': [
                  'Succeeded'
                ]
              }
              type: 'ParseJson'
            }
            'ProvisionGenie-CreateTeam': {
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
              runAfter: {
                For_each_related_Channel: [
                  'Succeeded'
                ]
              }
              type: 'Workflow'
            }
            Until_drive_exists: {
              actions: {
                Condition_DriveExistsCode_200: {
                  actions: {}
                  else: {
                    actions: {
                      Delay_2: {
                        inputs: {
                          interval: {
                            count: 30
                            unit: 'Second'
                          }
                        }
                        runAfter: {}
                        type: 'Wait'
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
                  runAfter: {
                    Update_DriveExistsCode: [
                      'Succeeded'
                    ]
                  }
                  type: 'If'
                }
                HTTP_to_check_if_root_drive_exists: {
                  inputs: {
                    authentication: {
                      audience: 'https://graph.microsoft.com'
                      identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_ProvisionGenie_ManagedIdentity_name)
                      type: 'ManagedServiceIdentity'
                    }
                    method: 'GET'
                    uri: 'https://graph.microsoft.com/v1.0/groups/@{body(\'Parse_HTTP_body_for_Team_Id\')?[\'TeamId\']}/drive/root'
                  }
                  runAfter: {}
                  type: 'Http'
                }
                Update_DriveExistsCode: {
                  inputs: {
                    name: 'DriveExistsCode'
                    value: '@outputs(\'HTTP_to_check_if_root_drive_exists\')[\'statusCode\']'
                  }
                  runAfter: {
                    HTTP_to_check_if_root_drive_exists: [
                      'Succeeded'
                    ]
                  }
                  type: 'SetVariable'
                }
              }
              description: 'Wait until the folder is created - otherwise following actions will fail'
              expression: '@equals(variables(\'DriveExistsCode\'), 200)'
              limit: {
                count: 1000
                timeout: 'PT1H'
              }
              runAfter: {
                Until_root_site_exists: [
                  'Succeeded'
                ]
              }
              type: 'Until'
            }
            Until_root_site_exists: {
              actions: {
                Compose_id: {
                  inputs: '@outputs(\'Get_Team_root_site\')?[\'body\'][\'id\']'
                  runAfter: {
                    Compose_webUrl: [
                      'Succeeded'
                    ]
                  }
                  type: 'Compose'
                }
                Compose_webUrl: {
                  inputs: '@outputs(\'Get_Team_root_site\')?[\'body\'][\'webUrl\']'
                  runAfter: {
                    Get_Team_root_site: [
                      'Succeeded'
                    ]
                  }
                  type: 'Compose'
                }
                Condition_SiteExistsCode_200: {
                  actions: {}
                  else: {
                    actions: {
                      Delay: {
                        inputs: {
                          interval: {
                            count: 30
                            unit: 'Second'
                          }
                        }
                        runAfter: {}
                        type: 'Wait'
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
                  runAfter: {
                    Update_SiteExistsCode: [
                      'Succeeded'
                    ]
                  }
                  type: 'If'
                }
                Get_Team_root_site: {
                  inputs: {
                    authentication: {
                      audience: 'https://graph.microsoft.com'
                      identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentities_ProvisionGenie_ManagedIdentity_name)
                      type: 'ManagedServiceIdentity'
                    }
                    method: 'GET'
                    uri: 'https://graph.microsoft.com/v1.0/groups/@{body(\'Parse_HTTP_body_for_Team_Id\')?[\'TeamId\']}/sites/root'
                  }
                  runAfter: {}
                  type: 'Http'
                }
                Update_SiteExistsCode: {
                  inputs: {
                    name: 'SiteExistsCode'
                    value: '@outputs(\'Get_Team_root_site\')[\'statusCode\']'
                  }
                  runAfter: {
                    Compose_id: [
                      'Succeeded'
                    ]
                  }
                  type: 'SetVariable'
                }
              }
              description: 'Wait until the root site exists - otherwise following actions will fail'
              expression: '@equals(variables(\'SiteExistsCode\'), 200)'
              limit: {
                count: 1000
                timeout: 'PT1H'
              }
              runAfter: {
                Parse_HTTP_body_for_Team_Id: [
                  'Succeeded'
                ]
              }
              type: 'Until'
            }
          }
          description: 'Get channel information, create team and wait for team creation to complete'
          runAfter: {
            Wait_1_minute_to_add_channels: [
              'Succeeded'
            ]
          }
          type: 'Scope'
        }
        SiteExistsCode: {
          inputs: {
            variables: [
              {
                name: 'SiteExistsCode'
                type: 'integer'
              }
            ]
          }
          runAfter: {
            DriveExistsCode: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
        }
        Wait_1_minute_to_add_channels: {
          description: 'Wait 1 minute to provide time for the channels to be linked to the team that has been created'
          inputs: {
            interval: {
              count: 1
              unit: 'Minute'
            }
          }
          runAfter: {
            Owners: [
              'Succeeded'
            ]
          }
          type: 'Wait'
        }
      }
      contentVersion: '1.0.0.0'
      outputs: {}
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
          type: 'ApiConnectionWebhook'
        }
      }
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
