param workflows_ProvisionGenie_CreateTaskList_name string
param userAssignedIdentities_ProvisionGenie_ManagedIdentity_name string
param workflows_ProvisionGenie_CreateListLibrary_name string
param resourceLocation string

resource workflows_ProvisionGenie_CreateTaskList_name_resource 'Microsoft.Logic/workflows@2019-05-01' = {
  name: workflows_ProvisionGenie_CreateTaskList_name
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
        'ProvisionGenie-CreateListLibrary': {
          runAfter: {
            listColumns: [
              'Succeeded'
            ]
          }
          type: 'Workflow'
          inputs: {
            body: {
              columns: '@variables(\'listColumns\')'
              resourceName: 'Task List'
              resourceType: 'List'
              siteId: '@triggerBody()?[\'siteId\']'
            }
            host: {
              triggerName: 'manual'
              workflow: {
                id: resourceId('Microsoft.Logic/workflows', workflows_ProvisionGenie_CreateListLibrary_name)
              }
            }
          }
        }
        Response: {
          runAfter: {
            'ProvisionGenie-CreateListLibrary': [
              'Succeeded'
            ]
          }
          type: 'Response'
          kind: 'Http'
          inputs: {
            statusCode: 200
          }
        }
        listColumns: {
          runAfter: {}
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'listColumns'
                type: 'array'
                value: [
                  {
                    columnName: 'Task Description'
                    columnType: 'Multiline text'
                    columnvalues: null
                  }
                  {
                    columnName: 'Start date'
                    columnType: 'Date'
                    columnvalues: null
                  }
                  {
                    columnName: 'Due date'
                    columnType: 'Date'
                    columnvalues: null
                  }
                  {
                    columnName: 'Assigned to'
                    columnType: 'Person'
                    columnvalues: null
                  }
                  {
                    columnName: 'Priority'
                    columnType: 'Choice'
                    columnvalues: [
                      'Normal'
                      'High'
                      'Low'
                    ]
                  }
                  {
                    columnName: 'Status'
                    columnType: 'Choice'
                    columnvalues: [
                      'Not started'
                      'In progress'
                      'Completed'
                      'Blocked'
                    ]
                  }
                ]
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
