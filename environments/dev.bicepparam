using '../modules/main.bicep'

param environment = 'dev'

param landingZones = {

  loadBalancers: [

    // ==================================================
    // ILB 1 - SQL AG
    //
    // Resource Group : rg-sql-ag-dev
    // VNet           : vnet-sql-ag-dev
    // Subnet         : sql-subnet
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
      // Multiple Frontend IP configurations
      // --------------------------------------------------

      frontends: [

        {
          name: 'sql-ag-frontend-01'
          privateIp: '10.10.1.20'
        }

        {
          name: 'sql-ag-frontend-02'
          privateIp: '10.10.1.22'
        }

        {
          name: 'sql-ag-frontend-03'
          privateIp: '10.10.1.23'
        }

      ]


      // --------------------------------------------------
      // IP-based Backend Address Pool
      // --------------------------------------------------

      backendPools: [

        {
          name: 'sql-ag-backend-pool'

          addresses: [

            {
              name: 'sql-backend-01'
              ipAddress: '10.10.1.30'
            }

            {
              name: 'sql-backend-02'
              ipAddress: '10.10.1.31'
            }

          ]
        }

      ]


      // --------------------------------------------------
      // Health probe
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
          name: 'sql-ag-rule-01'

          frontendName: 'sql-ag-frontend-01'

          backendPoolName: 'sql-ag-backend-pool'

          probeName: 'sql-ag-health-probe'

          protocol: 'Tcp'

          frontendPort: 1433

          backendPort: 1433

          idleTimeoutInMinutes: 4

          enableFloatingIp: true

          enableTcpReset: true
        }

        {
          name: 'sql-ag-rule-02'

          frontendName: 'sql-ag-frontend-02'

          backendPoolName: 'sql-ag-backend-pool'

          probeName: 'sql-ag-health-probe'

          protocol: 'Tcp'

          frontendPort: 1433

          backendPort: 1433

          idleTimeoutInMinutes: 4

          enableFloatingIp: true

          enableTcpReset: true
        }

        {
          name: 'sql-ag-rule-03'

          frontendName: 'sql-ag-frontend-03'

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
    //
    // Resource Group : rg-sql-ag-dev1
    // VNet           : vnet-sql-ag-dev1
    // Subnet         : sql-subnet1
    // ==================================================

    {
      resourceGroupName: 'rg-sql-ag-dev1'

      loadBalancerName: 'ilb-test-dev'

      location: 'centralus'

      skuName: 'Standard'

      skuTier: 'Regional'

      vnetName: 'vnet-sql-ag-dev1'

      subnetName: 'sql-subnet1'

      tags: {
        Environment: environment
        Project: 'ILB-Test'
        ManagedBy: 'Bicep'
        Owner: 'Infrastructure'
      }


      // --------------------------------------------------
      // Multiple Frontend IP configurations
      // --------------------------------------------------

      frontends: [

        {
          name: 'test-frontend-01'
          privateIp: '20.20.1.20'
        }

        {
          name: 'test-frontend-02'
          privateIp: '20.20.1.21'
        }

      ]


      // --------------------------------------------------
      // IP-based Backend Address Pool
      // --------------------------------------------------

      backendPools: [

        {
          name: 'test-backend-pool'

          addresses: [

            {
              name: 'test-backend-01'
              ipAddress: '20.20.1.30'
            }

            {
              name: 'test-backend-02'
              ipAddress: '20.20.1.31'
            }

          ]
        }

      ]


      // --------------------------------------------------
      // Health probe
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
          name: 'test-rule-01'

          frontendName: 'test-frontend-01'

          backendPoolName: 'test-backend-pool'

          probeName: 'test-health-probe'

          protocol: 'Tcp'

          frontendPort: 1433

          backendPort: 1433

          idleTimeoutInMinutes: 4

          enableFloatingIp: true

          enableTcpReset: true
        }

        {
          name: 'test-rule-02'

          frontendName: 'test-frontend-02'

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
