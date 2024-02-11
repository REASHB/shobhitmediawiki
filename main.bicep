param location string = 'northeurope'

@description('The name of your Virtual Machine.')
param vmName string = 'shobhit'


@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string = toLower('${vmName}-${uniqueString(resourceGroup().id)}')

resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
    name: 'shobhitNic'
    location: location
    properties: {
        ipConfigurations: [
            {
                name: 'ipconfig1'
                properties: {
                    subnet: {
                        id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'myVnet', 'mySubnet')
                    }
                    privateIPAllocationMethod: 'Dynamic'
                    publicIPAddress: {
                        id: publicIPAddress.id
                    }
                }
            }
        ]
    networkSecurityGroup: {
      id: networkSecurityGroup.id
    }
    }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'shobhitnsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
      {
        name: 'HTTPALOW'
        properties: {
          priority: 1010
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '0.0.0.0/0'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '80'
        }
      }
    ]
  }
}



resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
    name: 'myVnet'
    location: location
    properties: {
        addressSpace: {
            addressPrefixes: [
                '10.0.0.0/16'
            ]
        }
        subnets: [
            {
                name: 'mySubnet'
                properties: {
                    addressPrefix: '10.0.0.0/24'
                }
            }
        ]
    }
}

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: 'shobhitpip'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    publicIPAddressVersion: 'IPv4'
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
    idleTimeoutInMinutes: 4
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-04-01' = {
    name: 'shobhit'
    location: location
    properties: {
        hardwareProfile: {
            vmSize: 'Standard_D4s_v3'
        }
        storageProfile: {
            imageReference: {
                publisher: 'RedHat'
                offer: 'RHEL'
                sku: '7_9'
                version: 'latest'
            }
            osDisk: {
                createOption: 'FromImage'
                managedDisk: {
                    storageAccountType: 'Standard_LRS'
                }
            }
        }
        osProfile: {
            computerName: 'shobhit'
            adminUsername: 'adminUser'
            adminPassword: '*******'
        }
        networkProfile: {
            networkInterfaces: [
                {
                    id: nic.id
                }
            ]
        }
    }
}

