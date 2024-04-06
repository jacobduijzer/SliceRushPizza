@minLength(5)
@maxLength(50)
@description('Provide a project name for the naming of all resources')
param projectName string = 'slicerushpizza'

@description('Provide a location for the resources.')
param location string = 'westeurope'

module serviceBus 'modules/serviceBus.bicep' = {
  name: 'serviceBusModule'
  params: {
    projectName: projectName
    location: location
  }
}
