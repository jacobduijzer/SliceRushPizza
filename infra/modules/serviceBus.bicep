param projectName string
param location string

var serviceBusNamespaceName = 'sbns${projectName}'
var topicNewOrderName = '${serviceBusNamespaceName}/topic-new-order'
var subscriptionNewOrderName = '${topicNewOrderName}/sub-new-order-processing'

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
  dependsOn: [
    serviceBusNamespace
  ]
}

resource subNeworderprocessing 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2022-10-01-preview' = {
  name: subscriptionNewOrderName
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
  dependsOn: [
    topicNewOrders
  ]
}

resource ruleListen 'Microsoft.ServiceBus/namespaces/AuthorizationRules@2022-10-01-preview' = {
  name: '${serviceBusNamespaceName}/${topicNewOrderName}/listenRule'
  properties: {
    rights: [
      'Listen'
    ]
  }
}

resource ruleSend 'Microsoft.ServiceBus/namespaces/AuthorizationRules@2022-10-01-preview' = {
  name: '${serviceBusNamespaceName}/${topicNewOrderName}/sendRule'
  dependsOn: [
    ruleListen
  ]
  properties: {
    rights: [
      'Send'
    ]
  }
}

output ruleListenName string = ruleListen.name
output ruleSendName string = ruleSend.name

