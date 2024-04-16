@minLength(3)
@maxLength(50)
@description('Provide a project name for the naming of all resources')
param projectName string = 'srp'

@description('Provide a location for the resources.')
param location string = 'westeurope'

// existing storage account
var storageAccountName = 'sa${projectName}${uniqueString(resourceGroup().id)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: storageAccountName
}

resource tableService 'Microsoft.Storage/storageAccounts/tableServices@2023-01-01' existing = {
  name: 'default'
  parent: storageAccount
}

// existing app plan (?)
var hostingPlanName = 'plan-${projectName}-functionapps'

resource hostingPlan 'Microsoft.Web/serverfarms@2021-03-01' existing = {
  name: hostingPlanName
}

// create table in storage account


resource symbolicname 'Microsoft.Storage/storageAccounts/tableServices/tables@2023-01-01' = {
  name: 'products'
  parent: tableService
  properties: {
    signedIdentifiers: [
      {
        accessPolicy: {
          expiryTime: 'string'
          permission: 'string'
          startTime: 'string'
        }
        id: 'string'
      }
    ]
  }
}

// create new function app
// var functionAppName = 'fn-${projectName}-products'
