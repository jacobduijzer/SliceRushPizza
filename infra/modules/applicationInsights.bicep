param projectName string
param location string

var appiName = 'appi-${projectName}'
var logAnalyticsWorkspaceName = 'appi-law-${projectName}'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    retentionInDays: 30
    sku: {
      name: 'PerGB2018'
    }
  }
}

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
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}


// @description('Generated from /subscriptions/80c8c618-2d08-4bfb-82af-a75b5af71873/resourceGroups/DefaultResourceGroup-WEU/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-80c8c618-2d08-4bfb-82af-a75b5af71873-WEU')
// resource DefaultWorkspaceccdbfbafabafWEU 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
//   properties: {
//     customerId: 'c5b10ff8-b29d-4361-9f0c-2ecaa5f82b84'
//     provisioningState: 'Succeeded'
//     sku: {
//       name: 'PerGB2018'
//       lastSkuUpdate: '2024-03-12T13:39:15.5852408Z'
//     }
//     retentionInDays: 30
//     features: {
//       legacy: 0
//       searchVersion: 1
//       enableLogAccessUsingOnlyResourcePermissions: true
//     }
//     workspaceCapping: {
//       dailyQuotaGb: json('-1.0')
//       quotaNextResetTime: '2024-03-12T17:00:00Z'
//       dataIngestionStatus: 'RespectQuota'
//     }
//     publicNetworkAccessForIngestion: 'Enabled'
//     publicNetworkAccessForQuery: 'Enabled'
//     createdDate: '2024-03-12T13:39:15.5852408Z'
//     modifiedDate: '2024-03-12T13:39:16.9259893Z'
//   }
//   location: 'westeurope'
//   name: 'DefaultWorkspace-80c8c618-2d08-4bfb-82af-a75b5af71873-WEU'
//   etag: '"3700bc05-0000-0d00-0000-65f05b040000"'
// }

// @description('Generated from /subscriptions/80c8c618-2d08-4bfb-82af-a75b5af71873/resourceGroups/rg-slicerushpizza-westeurope/providers/microsoft.insights/components/appi-srp')
// resource appisrp 'Microsoft.Insights/components@2020-02-02' = {
//   name: 'appi-srp'
//   location: 'westeurope'
//   tags: {}
//   kind: 'web'
//   etag: '"190077ad-0000-0200-0000-6613d78f0000"'
//   properties: {
//     ApplicationId: 'appi-srp'
//     AppId: '0af4978e-1d5d-4120-93e0-650b2d3b16c6'
//     Application_Type: 'web'
//     Flow_Type: 'Redfield'
//     Request_Source: 'IbizaAIExtensionEnablementBlade'
//     InstrumentationKey: '01ba7f84-9871-4fdc-b838-a24818de9ac5'
//     ConnectionString: 'InstrumentationKey=01ba7f84-9871-4fdc-b838-a24818de9ac5;IngestionEndpoint=https://westeurope-5.in.applicationinsights.azure.com/;LiveEndpoint=https://westeurope.livediagnostics.monitor.azure.com/'
//     Name: 'appi-srp'
//     CreationDate: '2024-04-08T11:39:58.7379554+00:00'
//     TenantId: '80c8c618-2d08-4bfb-82af-a75b5af71873'
//     provisioningState: 'Succeeded'
//     SamplingPercentage: null
//     RetentionInDays: 90
//     WorkspaceResourceId: '/subscriptions/80c8c618-2d08-4bfb-82af-a75b5af71873/resourceGroups/DefaultResourceGroup-WEU/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-80c8c618-2d08-4bfb-82af-a75b5af71873-WEU'
//     IngestionMode: 'LogAnalytics'
//     publicNetworkAccessForIngestion: 'Enabled'
//     publicNetworkAccessForQuery: 'Enabled'
//     Ver: 'v2'
//   }
// }
