using '../modules/main.bicep'

param environment = 'dev'

param landingZones = {

  loadBalancers: [

    // ==================================================
    // ILB 1 - SQL AG
    // ==================================================

    {
      resourceGroupName: 'rg-sql-ag-dev'

      loadBalancerName: 'ilb-sql-ag-dev'

      location: 'centralus'

      skuName: 'Standard'

      skuTier: 'Regional'

      vnetName: 'vnet-sql-ag-dev'

      subnetName: 'sql-subnet'

      tags: {
        Environment: environment
        Project: 'SQL-AG'
        ManagedBy: 'Bicep'
        Owner: 'Infrastructure'
      }

      // --------------------------------------------------
      // Frontend IP configurations
      // --------------------------------------------------

      frontends: [

        {
          name: 'sql-ag-frontend'

          privateIp: '10.10.1.20'
        }

      ]

      // --------------------------------------------------
      // Backend address pools
      // --------------------------------------------------

      backendPools: [

        {
          name: 'sql-ag-backend-pool'

          addresses: []
        }

      ]

      // --------------------------------------------------
      // Health probes
      // --------------------------------------------------

      probes: [

        {
          name: 'sql-ag-health-probe'

          protocol: 'Tcp'

          port: 59999

          intervalInSeconds: 5

          numberOfProbes: 2
        }

      ]

      // --------------------------------------------------
      // Load balancing rules
      // --------------------------------------------------

      loadBalancingRules: [

        {
          name: 'sql-ag-rule'

          frontendName: 'sql-ag-frontend'

          backendPoolName: 'sql-ag-backend-pool'

          probeName: 'sql-ag-health-probe'

          protocol: 'Tcp'

          frontendPort: 1433

          backendPort: 1433

          idleTimeoutInMinutes: 4

          enableFloatingIp: true

          enableTcpReset: true
        }

      ]
    }


    // ==================================================
    // ILB 2 - TEST
    // ==================================================

    {
      resourceGroupName: 'rg-sql-ag-dev'

      loadBalancerName: 'ilb-test-dev'

      location: 'centralus'

      skuName: 'Standard'

      skuTier: 'Regional'

      vnetName: 'vnet-sql-ag-dev'

      subnetName: 'sql-subnet'

      tags: {
        Environment: environment
        Project: 'ILB-Test'
        ManagedBy: 'Bicep'
        Owner: 'Infrastructure'
      }

      // --------------------------------------------------
      // Frontend IP configurations
      // --------------------------------------------------

      frontends: [

        {
          name: 'test-frontend'

          privateIp: '10.10.1.21'
        }

      ]

      // --------------------------------------------------
      // Backend address pools
      // --------------------------------------------------

      backendPools: [

        {
          name: 'test-backend-pool'

          addresses: []
        }

      ]

      // --------------------------------------------------
      // Health probes
      // --------------------------------------------------

      probes: [

        {
          name: 'test-health-probe'

          protocol: 'Tcp'

          port: 59998

          intervalInSeconds: 5

          numberOfProbes: 2
        }

      ]

      // --------------------------------------------------
      // Load balancing rules
      // --------------------------------------------------

      loadBalancingRules: [

        {
          name: 'test-rule'

          frontendName: 'test-frontend'

          backendPoolName: 'test-backend-pool'

          probeName: 'test-health-probe'

          protocol: 'Tcp'

          frontendPort: 1433

          backendPort: 1433

          idleTimeoutInMinutes: 4

          enableFloatingIp: true

          enableTcpReset: true
        }

      ]
    }

  ]

}
