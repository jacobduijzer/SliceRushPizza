@minLength(3)
@maxLength(8)
@description('Provide a project name for the naming of all resources')
param projectName string = 'srp'

@description('Provide a location for the resources.')
param location string = 'westeurope'

// get existing resources
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: 'appi-${projectName}'
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: 'sa${projectName}${uniqueString(resourceGroup().id)}'
}

resource tableService 'Microsoft.Storage/storageAccounts/tableServices@2023-01-01' existing = {
  name: 'default'
  parent: storageAccount
}

resource hostingPlan 'Microsoft.Web/serverfarms@2021-03-01' existing = {
  name: 'plan-${projectName}-functionapps'
}

// create table in storage account

resource symbolicname 'Microsoft.Storage/storageAccounts/tableServices/tables@2023-01-01' = {
  name: 'products'
  parent: tableService
}

// create new function app
var functionAppName = 'fn-${projectName}-products'

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
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
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
      ]
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
    }
    httpsOnly: true
  }
}



