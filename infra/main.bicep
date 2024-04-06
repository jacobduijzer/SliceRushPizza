@minLength(5)
@maxLength(50)
@description('Provide a project name for the naming of all resources')
param projectName string = 'slicerushpizza'

@description('Provide a location for the resources.')
param location string = 'westeurope'

var resourceGroupName = 'rg-${projectName}-${location}'

targetScope = 'subscription'

module rg 'modules/resourceGroup.bicep' = {
  name: 'resourceGroupModule'
  params: {
    name: resourceGroupName
    location: location
  }
}
