param projectName string
param location string

var appiName = 'appi-${projectName}'

resource fnsrp 'Microsoft.Insights/components@2020-02-02' = {
  name: appiName
  location: location
  tags: {}
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Redfield'
    Request_Source: 'IbizaAIExtensionEnablementBlade'
    SamplingPercentage: null
    RetentionInDays: 90
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}
