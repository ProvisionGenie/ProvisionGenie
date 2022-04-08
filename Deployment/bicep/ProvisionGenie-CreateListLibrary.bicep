param workflows_ProvisionGenie_CreateListLibrary_name string = 'ProvisionGenie-CreateListLibrary'
param userAssignedIdentities_ProvisionGenie_ManagedIdentity_name string
param resourceLocation string

resource workflows_ProvisionGenie_CreateListLibrary_name_resource 'Microsoft.Logic/workflows@2019-05-01' = {
  name: workflows_ProvisionGenie_CreateListLibrary_name
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
                columns: {
                  items: {
                    properties: {
                      columnName: {
                        type: 'string'
                      }
                      columnType: {
                        type: 'string'
                      }
                      columnValues: {
                        type: 'array'
                      }
                    }
                    required: [
                      'columnName'
                      'columnType'
                      'columnValues'
                    ]
                    type: 'object'
                  }
                  type: 'array'
                }
                resourceName: {
                  type: 'string'
                }
                resourceType: {
                  type: 'string'
                }
                siteId: {
                  type: 'string'
                }
              }
              type: 'object'
            }
          }
        }
      }
      actions: {
        Columns: {
          runAfter: {}
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'Columns'
                type: 'array'
              }
            ]
          }
        }
        For_each_Column: {
          foreach: '@triggerBody()?[\'columns\']'
          actions: {
            Switch: {
              runAfter: {}
              cases: {
                Case_Choice: {
                  case: 'Choice'
                  actions: {
                    Append_choice_column_definition_to_Columns: {
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                      inputs: {
                        name: 'Columns'
                        value: {
                          choice: {
                            choices: '@items(\'For_each_Column\')?[\'columnValues\']'
                            displayAs: 'dropDownMenu'
                          }
                          name: '@{items(\'For_each_Column\')?[\'columnName\']}'
                        }
                      }
                    }
                  }
                }
                Case_Date: {
                  case: 'Date'
                  actions: {
                    Append_dateOnly_column_definition_to_Columns: {
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                      inputs: {
                        name: 'Columns'
                        value: {
                          dateTime: {
                            format: 'dateOnly'
                          }
                          name: '@{items(\'For_each_Column\')?[\'columnName\']}'
                        }
                      }
                    }
                  }
                }
                Case_DateTime: {
                  case: 'DateTime'
                  actions: {
                    Append_DateTime_column_definition_to_Columns: {
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                      inputs: {
                        name: 'Columns'
                        value: {
                          dateTime: {
                            format: 'dateTime'
                          }
                          name: '@{items(\'For_each_Column\')?[\'columnName\']}'
                        }
                      }
                    }
                  }
                }
                Case_Multiple_lines_of_text: {
                  case: 'Multiple lines of text'
                  actions: {
                    Append_multiline_text_column_definition_to_Columns: {
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                      inputs: {
                        name: 'Columns'
                        value: {
                          name: '@{items(\'For_each_Column\')?[\'columnName\']}'
                          text: {
                            allowMultipleLines: true
                            textType: 'plain'
                          }
                        }
                      }
                    }
                  }
                }
                Case_Number: {
                  case: 'Number'
                  actions: {
                    Append_number_column_definition_to_Columns: {
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                      inputs: {
                        name: 'Columns'
                        value: {
                          name: '@{items(\'For_each_Column\')?[\'columnName\']}'
                          number: {}
                        }
                      }
                    }
                  }
                }
                Case_Person: {
                  case: 'Person'
                  actions: {
                    Append_Person_column_definition_to_Columns: {
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                      inputs: {
                        name: 'Columns'
                        value: {
                          name: '@{items(\'For_each_Column\')?[\'columnName\']}'
                          personOrGroup: {
                            allowMultipleSelection: false
                            chooseFromType: 'peopleOnly'
                          }
                        }
                      }
                    }
                  }
                }
                Case_Text: {
                  case: 'Text'
                  actions: {
                    Append_text_column_definition_to_Columns: {
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                      inputs: {
                        name: 'Columns'
                        value: {
                          name: '@{items(\'For_each_Column\')?[\'columnName\']}'
                          text: {}
                        }
                      }
                    }
                  }
                }
                'Case_Yes/No': {
                  case: 'yes/no'
                  actions: {
                    Append_boolean_column_definition_to_Columns: {
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                      inputs: {
                        name: 'Columns'
                        value: {
                          boolean: {}
                          name: '@{items(\'For_each_Column\')?[\'columnName\']}'
                        }
                      }
                    }
                  }
                }
              }
              default: {
                actions: {}
              }
              expression: '@items(\'For_each_Column\')?[\'columnType\']'
              type: 'Switch'
            }
          }
          runAfter: {
            ResourceType: [
              'Succeeded'
            ]
          }
          type: 'Foreach'
          runtimeConfiguration: {
            concurrency: {
              repetitions: 1
            }
          }
        }
        HTTP_create_resource: {
          runAfter: {
            Switch_resourceType: [
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
              columns: '@variables(\'Columns\')'
              displayName: '@{triggerBody()?[\'resourceName\']}'
              list: {
                template: '@{variables(\'ResourceType\')}'
              }
            }
            headers: {
              'content-type': 'application/json'
            }
            method: 'POST'
            uri: 'https://graph.microsoft.com/v1.0/sites/@{triggerBody()?[\'siteId\']}/lists'
          }
        }
        ResourceType: {
          runAfter: {
            Columns: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'ResourceType'
                type: 'string'
              }
            ]
          }
        }
        Response: {
          runAfter: {
            HTTP_create_resource: [
              'Succeeded'
            ]
          }
          type: 'Response'
          kind: 'Http'
          inputs: {
            body: {
              resourceId: '@{body(\'HTTP_create_resource\')[\'id\']}'
              webUrl: '@{body(\'HTTP_create_resource\')[\'webUrl\']}'
            }
            headers: {
              'content-type': 'application/json'
            }
            statusCode: 200
          }
        }
        Switch_resourceType: {
          runAfter: {
            For_each_Column: [
              'Succeeded'
            ]
          }
          cases: {
            Case_Library: {
              case: 'Library'
              actions: {
                Set_ResourceType_to_Library: {
                  runAfter: {}
                  type: 'SetVariable'
                  inputs: {
                    name: 'ResourceType'
                    value: 'documentLibrary'
                  }
                }
              }
            }
            Case_List: {
              case: 'List'
              actions: {
                Set_ResourceType_to_List: {
                  runAfter: {}
                  type: 'SetVariable'
                  inputs: {
                    name: 'ResourceType'
                    value: 'genericList'
                  }
                }
              }
            }
          }
          default: {
            actions: {}
          }
          expression: '@triggerBody()?[\'resourceType\']'
          type: 'Switch'
        }
      }
      outputs: {}
    }
    parameters: {}
  }
}
