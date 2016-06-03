client = {
  url: '',
  user: '',
  password: '',
  ssl_enabled: false
}

oneview_logical_enclosure 'Encl1' do
  client client
  action :update_from_group
end
