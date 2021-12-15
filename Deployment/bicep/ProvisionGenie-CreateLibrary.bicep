param workflows_ProvisionGenie_CreateLibrary_name string
param userAssignedIdentities_ProvisionGenie_ManagedIdentity_name string
param resourceLocation string

resource workflows_ProvisionGenie_CreateLibrary_name_resource 'Microsoft.Logic/workflows@2019-05-01' = {
  name: workflows_ProvisionGenie_CreateLibrary_name
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
                libraryColumns: {
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
                libraryName: {
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
        For_each_libraryColumn: {
          foreach: '@triggerBody()?[\'libraryColumns\']'
          actions: {
            Switch: {
              runAfter: {}
              cases: {
                Case_Choice: {
                  case: 'Choice'
                  actions: {
                    Append_choice_column_definition_to_ListColumns: {
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                      inputs: {
                        name: 'LibraryColumns'
                        value: {
                          choice: {
                            choices: '@items(\'For_each_libraryColumn\')?[\'columnValues\']'
                            displayAs: 'dropDownMenu'
                          }
                          name: '@{items(\'For_each_libraryColumn\')?[\'columnName\']}'
                        }
                      }
                    }
                  }
                }
                Case_Date: {
                  case: 'Date'
                  actions: {
                    Append_dateOnly_column_definition_to_ListColumns: {
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                      inputs: {
                        name: 'LibraryColumns'
                        value: {
                          dateTime: {
                            format: 'dateOnly'
                          }
                          name: '@{items(\'For_each_libraryColumn\')?[\'columnName\']}'
                        }
                      }
                    }
                  }
                }
                Case_DateTime: {
                  case: 'DateTime'
                  actions: {
                    Append_DateTime_column_definition_to_ListColumns: {
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                      inputs: {
                        name: 'LibraryColumns'
                        value: {
                          dateTime: {
                            format: 'dateTime'
                          }
                          name: '@{items(\'For_each_libraryColumn\')?[\'columnName\']}'
                        }
                      }
                    }
                  }
                }
                Case_Multiple_lines_of_text: {
                  case: 'Multiple lines of text'
                  actions: {
                    Append_multiline_text_column_definition_to_LibraryColumns: {
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                      inputs: {
                        name: 'LibraryColumns'
                        value: {
                          name: '@{items(\'For_each_libraryColumn\')?[\'columnName\']}'
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
                    Append_number_column_definition_to_ListColumns: {
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                      inputs: {
                        name: 'LibraryColumns'
                        value: {
                          name: '@{items(\'For_each_libraryColumn\')?[\'columnName\']}'
                          number: {}
                        }
                      }
                    }
                  }
                }
                Case_Person: {
                  case: 'Person'
                  actions: {
                    Append_Person_column_definition_to_LibraryColumns: {
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                      inputs: {
                        name: 'LibraryColumns'
                        value: {
                          name: '@{items(\'For_each_libraryColumn\')?[\'columnName\']}'
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
                    Append_text_column_definition_to_ListColumns: {
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                      inputs: {
                        name: 'LibraryColumns'
                        value: {
                          name: '@{items(\'For_each_libraryColumn\')?[\'columnName\']}'
                          text: {}
                        }
                      }
                    }
                  }
                }
                'Case_Yes/No': {
                  case: 'yes/no'
                  actions: {
                    Append_boolean_column_definition_to_ListColumns: {
                      runAfter: {}
                      type: 'AppendToArrayVariable'
                      inputs: {
                        name: 'LibraryColumns'
                        value: {
                          boolean: {}
                          name: '@{items(\'For_each_libraryColumn\')?[\'columnName\']}'
                        }
                      }
                    }
                  }
                }
              }
              default: {
                actions: {}
              }
              expression: '@items(\'For_each_libraryColumn\')?[\'columnType\']'
              type: 'Switch'
            }
          }
          runAfter: {
            LibraryColumns: [
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
        HTTP_create_library: {
          runAfter: {
            For_each_libraryColumn: [
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
              columns: '@variables(\'LibraryColumns\')'
              displayName: '@{triggerBody()?[\'libraryName\']}'
              list: {
                template: 'documentLibrary'
              }
            }
            headers: {
              'content-type': 'application/json'
            }
            method: 'POST'
            uri: 'https://graph.microsoft.com/v1.0/sites/@{triggerBody()?[\'siteId\']}/lists'
          }
        }
        LibraryColumns: {
          runAfter: {}
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
        Response: {
          runAfter: {
            HTTP_create_library: [
              'Succeeded'
            ]
          }
          type: 'Response'
          kind: 'Http'
          inputs: {
            body: {
              libraryId: '@{body(\'HTTP_create_library\')[\'id\']}'
            }
            headers: {
              'content-type': 'application/json'
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
