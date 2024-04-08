@minLength(3)
@maxLength(50)
@description('Provide a project name for the naming of all resources')
param projectName string = 'srp'

@description('Provide a location for the resources.')
param location string = 'westeurope'

module applicationInsights 'modules/applicationInsights.bicep' = {
  name: 'ApplicationInsights'
  params: {
    projectName: projectName
    location: location
  }
}

module storageAccount 'modules/storageAccount.bicep' = {
  name: 'StorageAccount'
  params: {
    projectName: projectName
    location: location
  }
}

module containerRegistry 'modules/containerRegistry.bicep' = {
  name: 'ContainerRegistry'
  params: {
    projectName: projectName
    location: location
  }
}

module serviceBus 'modules/serviceBus.bicep' = {
  name: 'ServiceBus'
  params: {
    projectName: projectName
    location: location
  }
}

module functionApp 'modules/functionApp.bicep' = {
  name: 'FunctionApp'
  params: { 
    projectName: projectName
    location: location
    applicationInsightsName: applicationInsights.outputs.appiName
    storageAccountName: storageAccount.outputs.name
    newOrdersTopicName: serviceBus.outputs.topicNewOrdersName
    newOrdersSubscriptionName: serviceBus.outputs.subscriptionNewOrdersName
    newOrdersListenRuleConnectionString: serviceBus.outputs.connectionStringNewOrdersListen
    newOrdersSendRuleConnectionString: serviceBus.outputs.connectionStringNewOrdersSend
    newPaymentsTopicName: serviceBus.outputs.topicNewPaymentName
    newPaymentsSubscriptionName: serviceBus.outputs.subscriptionNewPaymentName
    newPaymentsListenRuleConnectionString: serviceBus.outputs.connectionStringNewPaymentsListen
    newPaymentsSendRuleConnectionString: serviceBus.outputs.connectionStringNewPaymentsSend
  }
  dependsOn: [
    storageAccount
    serviceBus
  ]
}
