require 'oneview-sdk'

client_2 = {
  url: 'https://172.16.101.48', # or set ENV['ONEVIEWSDK_URL']
  user: 'Administrator', # or set ENV['ONEVIEWSDK_USER']
  password: 'rainforest', # or set ENV['ONEVIEWSDK_PASSWORD']
  ssl_enabled: false
}

ethernet_network 'eth1' do
  data (
    {
      vlanId:  '1001',
      purpose:  'General',
      name:  'eth1',
      smartLink:  false,
      privateNetwork:  false
    }
  )
  client client_2
  action :create
end
