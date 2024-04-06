param projectName string
param location string

var serviceBusNamespaceName = 'sbns${projectName}'
var serviceBusQueueName = 'sbq-${projectName}-${location}-${uniqueString(resourceGroup().id)}'
var topicNewOrderName = '${serviceBusQueueName}/topic-new-order'

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: serviceBusNamespaceName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {}
}

// resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2022-10-01-preview' = {
//   parent: serviceBusNamespace
//   name: serviceBusQueueName
//   properties: {
//     lockDuration: 'PT5M'
//     maxSizeInMegabytes: 1024
//     requiresDuplicateDetection: false
//     requiresSession: false
//     defaultMessageTimeToLive: 'P10675199DT2H48M5.4775807S'
//     deadLetteringOnMessageExpiration: false
//     duplicateDetectionHistoryTimeWindow: 'PT10M'
//     maxDeliveryCount: 10
//     autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
//     enablePartitioning: false
//     enableExpress: false
//   }
// }

resource topicNewOrders 'Microsoft.ServiceBus/namespaces/topics@2022-10-01-preview' = {
  name: topicNewOrderName
  properties: {
    maxMessageSizeInKilobytes: 256
    defaultMessageTimeToLive: 'P14D'
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: false
    duplicateDetectionHistoryTimeWindow: 'PT10M'
    enableBatchedOperations: true
    supportOrdering: false
    autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
    enablePartitioning: false
    enableExpress: false
  }
}
