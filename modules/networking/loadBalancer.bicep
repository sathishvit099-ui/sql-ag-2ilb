@description('Load Balancer name')
param loadBalancerName string

@description('Azure region')
param location string

@description('Load Balancer SKU name')
param skuName string

@description('Load Balancer SKU tier')
param skuTier string

@description('Resource tags')
param tags object

@description('Existing Virtual Network name')
param vnetName string

@description('Existing subnet name')
param subnetName string

@description('Frontend IP configurations')
param frontends array

@description('Backend address pool configurations')
param backendPools array

@description('Health probes')
param probes array

@description('Load balancing rules')
param loadBalancingRules array


// ======================================================
// Existing VNet
// ======================================================

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2025-05-01' existing = {
  name: vnetName
}


// ======================================================
// Existing subnet
// ======================================================

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2025-05-05' existing = {
  parent: virtualNetwork
  name: subnetName
}


// ======================================================
// Internal Load Balancer
// ======================================================

resource loadBalancer 'Microsoft.Network/loadBalancers@2025-05-01' = {
  name: loadBalancerName
  location: location
  tags: tags

  sku: {
    name: skuName
    tier: skuTier
  }

  properties: {

    // ==================================================
    // Frontend IP configurations
    // ==================================================

    frontendIPConfigurations: [
      for frontend in frontends: {
        name: frontend.name

        properties: {
          privateIPAddress: frontend.privateIp
          privateIPAllocationMethod: 'Static'

          subnet: {
            id: subnet.id
          }
        }
      }
    ]


    // ==================================================
    // Health probes
    // ==================================================

    probes: [
      for probe in probes: {
        name: probe.name

        properties: {
          protocol: probe.protocol
          port: probe.port
          intervalInSeconds: probe.intervalInSeconds
          numberOfProbes: probe.numberOfProbes
        }
      }
    ]


    // ==================================================
    // Load balancing rules
    // ==================================================

    loadBalancingRules: [
      for rule in loadBalancingRules: {
        name: rule.name

        properties: {

          frontendIPConfiguration: {
            id: resourceId(
              'Microsoft.Network/loadBalancers/frontendIPConfigurations',
              loadBalancerName,
              rule.frontendName
            )
          }

          backendAddressPool: {
            id: resourceId(
              'Microsoft.Network/loadBalancers/backendAddressPools',
              loadBalancerName,
              rule.backendPoolName
            )
          }

          probe: {
            id: resourceId(
              'Microsoft.Network/loadBalancers/probes',
              loadBalancerName,
              rule.probeName
            )
          }

          protocol: rule.protocol

          frontendPort: rule.frontendPort

          backendPort: rule.backendPort

          idleTimeoutInMinutes: rule.idleTimeoutInMinutes

          enableFloatingIP: rule.enableFloatingIp

          enableTcpReset: rule.enableTcpReset
        }
      }
    ]
  }
}


// ======================================================
// Backend Address Pools
//
// IMPORTANT:
// These are child resources of the Load Balancer.
//
// Each backend member is configured using:
//   IP address
//   + subnet reference
//
// Therefore this is IP-based backend configuration,
// not NIC-based backend configuration.
// ======================================================

resource backendAddressPool 'Microsoft.Network/loadBalancers/backendAddressPools@2025-05-01' = [
  for backendPool in backendPools: {
    parent: loadBalancer

    name: backendPool.name

    properties: {

      loadBalancerBackendAddresses: [
        for backend in backendPool.addresses: {
          name: backend.name

          properties: {
            ipAddress: backend.ipAddress

            subnet: {
              id: subnet.id
            }
          }
        }
      ]
    }
  }
]


output loadBalancerId string = loadBalancer.id

output loadBalancerName string = loadBalancer.name
