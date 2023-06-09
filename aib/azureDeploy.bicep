//Parameters
param resourceGroupName string
param location string
param identityName string
param computeGalleryName string
param imageDefinitionName string
param imageTemplateName string
param sourceImagePublisher string
param sourceImageOffer string
param sourceImageSku string
param sourceImageVersion string
param vmSize string
param diskSize int
param OptimizeOsScriptURI string
param CustomAppsURI string


// Define target scope
targetScope = 'subscription'

//Create resource group
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01'= {
  name: resourceGroupName
  location: location
}

//Create user assigned managed identity
module identity './modules/identity.bicep' = {
  name: 'identityDeployment'
  scope: rg    
  params: {
    identityName: identityName
    location: location
  }
}

//Assign RBAC to the user assigned managed identity
module rbac './modules/rbac.bicep' = {
  name: 'rbacDeployment'
  scope: rg    
  params: {
    identityName: identityName
  }
  dependsOn: [
    identity
  ]
}

//Create Azure Compute Gallery
module acg './modules/computeGallery.bicep' = {
  name: 'acgDeployment'
  scope: rg    
  params: {
    computeGalleryName: computeGalleryName
    location: location
  }
}

//Create image defination
module imagedef './modules/imageDefinition.bicep' = {
  name: 'imagedefDeployment'
  scope: rg   
  params: {
    computeGalleryName: computeGalleryName
    imageDefinitionName: imageDefinitionName
    location: location
  }
  dependsOn: [
    acg
  ]
}

//Create image template
module imageTemplate './modules/imageTemplate.bicep' = {
  name: 'imageTemplateDeployment'
  scope: rg   
  params: {
    imageTemplateName: imageTemplateName
    imageDefinitionName: imageDefinitionName
    sourceImagePublisher: sourceImagePublisher
    sourceImageOffer: sourceImageOffer
    sourceImageSku: sourceImageSku
    sourceImageVersion: sourceImageVersion
    identityName: identityName
    computeGalleryName: computeGalleryName
    vmSize: vmSize
    diskSize: diskSize
    location: location
    OptimizeOsScriptURI: OptimizeOsScriptURI
    CustomAppsURI: CustomAppsURI
  }
  dependsOn: [
    imagedef
  ]
}
