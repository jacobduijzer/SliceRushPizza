@description('Provide a name for the resource group')
param name string

@description('Provide a location for the resources.')
param location string

targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: name
  location: location
}

output id string = rg.id
