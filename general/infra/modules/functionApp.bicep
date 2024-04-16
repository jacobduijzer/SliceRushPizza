param projectName string
param location string
param applicationInsightsName string
param storageAccountName string
param newOrdersTopicName string
param newOrdersSubscriptionName string
param newOrdersListenRuleConnectionString string
param newOrdersSendRuleConnectionString string
param newPaymentsTopicName string
param newPaymentsSubscriptionName string
param newPaymentsListenRuleConnectionString string
param newPaymentsSendRuleConnectionString string

var hostingPlanName = 'plan-${projectName}-functionapps'
var functionAppName = 'fn-${projectName}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: storageAccountName
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: applicationInsightsName
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
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: applicationInsights.properties.ConnectionString
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'AzureServiceBusOrdersListenConnectionString'
          value: newOrdersListenRuleConnectionString
        }
        {
          name: 'AzureServiceBusOrdersSendConnectionString'
          value: newOrdersSendRuleConnectionString
        }
        {
          name: 'NewOrdersTopicName'
          value: newOrdersTopicName
        }
        {
          name: 'NewOrdersSubscriptionName'
          value: newOrdersSubscriptionName
        }
        {
          name: 'AzureServiceBusPaymentsListenConnectionString'
          value: newPaymentsListenRuleConnectionString
        }
        {
          name: 'AzureServiceBusPaymentsSendConnectionString'
          value: newPaymentsSendRuleConnectionString
        }
        {
          name: 'NewPaymentsTopicName'
          value: newPaymentsTopicName
        }
        {
          name: 'NewPaymentsSubscriptionName'
          value: newPaymentsSubscriptionName
        }
      ]
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
    }
    httpsOnly: true
  }
}
