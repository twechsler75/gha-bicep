targetScope = 'subscription'

param azureRegion string = 'switzerlandnorth'
param resourceGroupName string = 'ctt-rg-${azureRegion}'
param projectNameTag string = 'Production'
param projectEnvTag string = 'DevOps'

resource cttresourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: azureRegion
  tags:{
    Project: projectNameTag
    Environment: projectEnvTag
  }
}

module appServices 'modules/web-app.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'appDeployment-${uniqueString(cttresourceGroup.id)}'
  params: {
    azureRegion: azureRegion
    appServiceAppDevName: 'appDev${uniqueString(cttresourceGroup.id)}'
    appServiceAppTestName: 'appTest${uniqueString(cttresourceGroup.id)}'
    appServicePlanName: 'ctt-appServicePlan'
    projectNameTag: projectNameTag
    projectEnvTag: projectEnvTag
  }
}

module storageServices 'modules/storage.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'stgDeployment-${uniqueString(cttresourceGroup.id)}'
  params: {
    azureRegion: azureRegion
    accountNamePrefix: 'ctt001'
    projectNameTag: projectNameTag
    projectEnvTag: projectEnvTag
  }
}

module networkServices 'modules/vnet.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'vnetDeployment-${uniqueString(cttresourceGroup.id)}'
  params: {
    location: azureRegion
    prefix: 'ctt-devops'
  }
}
