module OneviewCookbook
  module API200
    module EthernetNetworkProvider
      include OneviewCookbook::Helper
      include OneviewCookbook::Helper::MissingResource
      include OneviewCookbook::ResourceBase

      def update_connection_template(item, bandwidth)
        bandwidth = convert_keys(bandwidth, :to_s)
        connection_template = Helper.oneview_api::ConnectionTemplate.new(item.client, uri: item['connectionTemplateUri'])
        connection_template.retrieve!
        if connection_template.like? bandwidth
          Chef::Log.info("#{resource_name} '#{name}' connection template is up to date")
        else
          converge_by "Update #{resource_name} '#{name}' connection template settings" do
            connection_template.update(bandwidth)
          end
        end
      end

      def create_ethernet_network
        item = load_resource
        bandwidth = item.data.delete('bandwidth')
        create_or_update(item)
        update_connection_template(item, bandwidth: bandwidth) if bandwidth
      end

      def create_ethernet_network_if_missing
        item = load_resource
        bandwidth = item.data.delete('bandwidth')
        created = create_if_missing(item)
        update_connection_template(item, bandwidth: bandwidth) if bandwidth && created
      end

      def reset_ethernet_network_connection_template
        item = load_resource
        item.retrieve!
        update_connection_template(item, bandwidth: Helper.oneview_api::ConnectionTemplate.get_default(item.client)['bandwidth'])
      end
    end
  end
end
