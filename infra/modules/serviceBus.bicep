param projectName string
param location string

var serviceBusNamespaceName = 'sbns${projectName}'
var topicNewOrderName = 'topic-new-order'
var subscriptionNewOrderName = 'sub-new-order-processing'

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: serviceBusNamespaceName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {}
}

resource topicNewOrders 'Microsoft.ServiceBus/namespaces/topics@2022-10-01-preview' = {
  name: topicNewOrderName
  parent: serviceBusNamespace
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

resource subNeworderprocessing 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2022-10-01-preview' = {
  name: subscriptionNewOrderName
  parent: topicNewOrders
  properties: {
    isClientAffine: false
    lockDuration: 'PT1M'
    requiresSession: false
    defaultMessageTimeToLive: 'P14D'
    deadLetteringOnMessageExpiration: false
    deadLetteringOnFilterEvaluationExceptions: false
    maxDeliveryCount: 10
    status: 'Active'
    enableBatchedOperations: true
    autoDeleteOnIdle: 'P14D'
  }
}

resource ruleListen 'Microsoft.ServiceBus/namespaces/topics/AuthorizationRules@2022-10-01-preview' = {
  name: 'listenRule'
  parent: topicNewOrders
  properties: {
    rights: [
      'Listen'
    ]
  }
}

resource ruleSend 'Microsoft.ServiceBus/namespaces/topics/AuthorizationRules@2022-10-01-preview' = {
  name: 'sendRule'
  parent: topicNewOrders
  dependsOn: [
    ruleListen
  ]
  properties: {
    rights: [
      'Send'
    ]
  }
}

output ruleListenConnectionString string = ruleListen.listKeys().primaryConnectionString
output ruleSendConnectionString string = ruleSend.listKeys().primaryConnectionString
output topicNewOrderName string = topicNewOrderName
output subscriptionNewOrderName string = subscriptionNewOrderName

