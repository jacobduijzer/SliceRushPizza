@minLength(3)
@maxLength(50)
@description('Provide a project name for the naming of all resources')
param projectName string = 'srp'

@description('Provide a location for the resources.')
param location string = 'westeurope'

module storageAccount 'modules/storageAccount.bicep' = {
  name: 'storageAccountModule'
  params: {
    projectName: projectName
    location: location
  }
}

module containerRegistry 'modules/containerRegistry.bicep' = {
  name: 'containerRegistryModule'
  params: {
    projectName: projectName
    location: location
  }
}

module serviceBus 'modules/serviceBus.bicep' = {
  name: 'serviceBusModule'
  params: {
    projectName: projectName
    location: location
  }
}

module functionApp 'modules/functionApp.bicep' = {
  name: 'functionAppModule'
  params: { 
    projectName: projectName
    location: location
    storageAccountName: storageAccount.outputs.name
  }
  dependsOn: [
    storageAccount
  ]
}
