targetScope = 'subscription'

@description('Deployment environment')
param environment string

@description('SQL AG Load Balancer configuration')
param landingZones object


module loadBalancerModule './networking/loadBalancer.bicep' = [
  for lb in landingZones.loadBalancers: {
    name: 'lb-${lb.loadBalancerName}-${environment}'

    scope: resourceGroup(lb.resourceGroupName)

    params: {
      loadBalancerName: lb.loadBalancerName
      location: lb.location

      skuName: lb.skuName
      skuTier: lb.skuTier

      tags: lb.tags

      vnetName: lb.vnetName
      subnetName: lb.subnetName

      frontends: lb.frontends

      backendPools: lb.backendPools

      probes: lb.probes

      loadBalancingRules: lb.loadBalancingRules
    }
  }
]
