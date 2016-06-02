client = {
  url: '',
  user: '',
  password: '',
  ssl_enabled: false
}

oneview_enclosure_group 'Eg2' do
  data ({
    stackingMode: 'Enclosure',
    interconnectBayMappingCount: 8
  })
  logical_interconnect_group 'lig1'
  client client
  action :create
end

oneview_enclosure_group 'Eg2' do
  client client
  action :delete
end
