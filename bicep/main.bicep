targetScope = 'subscription'

param rgName string = 'rg-kv'
param location string = 'westeurope'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgName
  location: location
}

module kv 'KeyVault.bicep' = {
  scope: rg
  name: 'keyvault'
  params: {
    secretName: 'topsecret'
    secretValue: 'abcd'
    location: location
  }
}
