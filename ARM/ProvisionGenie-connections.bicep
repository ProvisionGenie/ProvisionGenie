param connections_commondataservice_name string
param resourceLocation string
param subscriptionID string

resource connections_commondataservice_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name:connections_commondataservice_name
  location:resourceLocation
  // kind: 'V1' - seems to be not working
  properties:{
    displayName:connections_commondataservice_name
    customParameterValues:{}
    api:{
      id:'subscriptions/${subscriptionID}/providers/Microsoft.Web/locations/${resourceLocation}/managedApis/${connections_commondataservice_name}'
    }
  }
}
