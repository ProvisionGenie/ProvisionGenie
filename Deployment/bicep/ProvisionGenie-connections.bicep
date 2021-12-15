param connections_commondataservice_name string
param resourceLocation string
param servicePrincipal_AppId string

@secure()
param servicePrincipal_ClientSecret string
param servicePrincipal_TenantId string

resource connections_commondataservice_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_commondataservice_name
  location: resourceLocation
  kind: 'V1'
  properties: {
    displayName: connections_commondataservice_name
    parameterValues: {
      'token:clientId': servicePrincipal_AppId
      'token:clientSecret': servicePrincipal_ClientSecret
      'token:TenantId': servicePrincipal_TenantId
      'token:grantType': 'client_credentials'
    }
    api: {
      id: '${subscription().id}/providers/Microsoft.Web/locations/${resourceLocation}/managedApis/commondataservice'
    }
  }
}
