param projectName string
param location string
param storageAccountName string
param newOrderTopicName string
param newOrderSubscriptionName string
param listenRuleConnectionString string
param ruleSendConnectionString string

var hostingPlanName = 'plan-${projectName}-functionapps'
var functionAppName = 'fn-${projectName}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: storageAccountName
}

resource hostingPlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: hostingPlanName
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {}
}

resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: hostingPlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionAppName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~14'
        }
        // {
        //   name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
        //   value: applicationInsights.properties.InstrumentationKey
        // }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'AzureServiceBusOrdersListenConnectionString'
          value: listenRuleConnectionString
        }
        {
          name: 'AzureServiceBusOrdersSendConnectionString'
          value: ruleSendConnectionString
        }
        {
          name: 'NewOrdersTopicName'
          value: newOrderTopicName
        }
        {
          name: 'NewOrdersSubscriptionName'
          value: newOrderSubscriptionName
        }
      ]
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
    }
    httpsOnly: true
  }
}



