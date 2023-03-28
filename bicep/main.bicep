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
    secretName: 'GitHub-almalos-bicep-id'
    secretValue: '7dc1d122-9331-4548-9931-a3f2ea74a1cd'
    location: location
  }
}
