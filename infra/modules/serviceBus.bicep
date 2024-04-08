param projectName string
param location string

var serviceBusNamespaceName = 'sbns${projectName}'
var topicNewOrderName = 'topic-new-order'
var subscriptionNewOrderName = 'sub-new-order-processing'
var topicNewPaymentName = 'topic-new-payment'
var subscriptionNewPaymentName = 'sub-new-payment-processing'

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

resource subNewOrderprocessing 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2022-10-01-preview' = {
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

resource newOrderListenRule 'Microsoft.ServiceBus/namespaces/topics/AuthorizationRules@2022-10-01-preview' = {
  name: 'new-order-listen'
  parent: topicNewOrders
  properties: {
    rights: [
      'Listen'
    ]
  }
}

resource newOrderSendRule 'Microsoft.ServiceBus/namespaces/topics/AuthorizationRules@2022-10-01-preview' = {
  name: 'new-order-send'
  parent: topicNewOrders
  dependsOn: [
    newOrderListenRule
  ]
  properties: {
    rights: [
      'Send'
    ]
  }
}

// Payment

resource topicNewPayment 'Microsoft.ServiceBus/namespaces/topics@2022-10-01-preview' = {
  name: topicNewPaymentName
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

resource subNewPaymentPocessing 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2022-10-01-preview' = {
  name: subscriptionNewPaymentName
  parent: topicNewPayment
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

resource newPaymentListenRule 'Microsoft.ServiceBus/namespaces/topics/AuthorizationRules@2022-10-01-preview' = {
  name: 'new-payment-listen'
  parent: topicNewPayment
  properties: {
    rights: [
      'Listen'
    ]
  }
}

resource newPaymentSendRule 'Microsoft.ServiceBus/namespaces/topics/AuthorizationRules@2022-10-01-preview' = {
  name: 'new-payment-send'
  parent: topicNewPayment
  dependsOn: [
    newPaymentListenRule
  ]
  properties: {
    rights: [
      'Send'
    ]
  }
}

output topicNewOrdersName string = topicNewOrderName
output subscriptionNewOrdersName string = subscriptionNewOrderName
output connectionStringNewOrdersListen string = newOrderListenRule.listKeys().primaryConnectionString
output connectionStringNewOrdersSend string = newOrderSendRule.listKeys().primaryConnectionString

output topicNewPaymentName string = topicNewPaymentName
output subscriptionNewPaymentName string = subscriptionNewPaymentName
output connectionStringNewPaymentsListen string = newOrderListenRule.listKeys().primaryConnectionString
output connectionStringNewPaymentsSend string = newOrderSendRule.listKeys().primaryConnectionString

