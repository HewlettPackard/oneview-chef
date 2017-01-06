module OneviewCookbook
  module API200
    #  Network Set Provider resource methods
    module NetworkSetProvider
      include OneviewCookbook::Helper
      include OneviewCookbook::Helper::MissingResource
      include OneviewCookbook::ResourceBase

      def load_resource_with_properties
        item = load_resource
        if native_network
          native_net = Helper.oneview_api::EthernetNetwork.find_by(item.client, name: native_network).first
          raise "Native network #{native_network} not found!" unless native_net
          item.set_native_network(native_net)
        end

        if ethernet_network_list
          ethernet_network_list.each do |net_name|
            net = Helper.oneview_api::EthernetNetwork.find_by(item.client, name: net_name).first
            raise "Network #{net_name} not found!" unless net
            item.add_ethernet_network(net)
          end
        end
        item
      end

      # It should compare the networkUris regardless of how they are sorted in the array.
      # This actually is not supported by the Helper.oneview_api::Resource#like? and probably it will not be.
      def create_network_set
        ret_val = false
        item = load_resource_with_properties
        temp = Marshal.load(Marshal.dump(item.data))
        if item.exists?
          create_if_exists(item, temp)
        else
          Chef::Log.info "Create #{resource_name} '#{name}'"
          converge_by "Create #{resource_name} '#{name}'" do
            item.create
          end
          ret_val = true
        end
        save_res_info(save_resource_info, name, item)
        ret_val
      end

      def create_if_exists(item, temp)
        item.retrieve!
        retrieved_networks = item.data.delete('networkUris')
        desired_networks = temp.delete('networkUris')
        temp['connectionTemplateUri'] ||= item['connectionTemplateUri']
        networks_match = retrieved_networks.to_a.sort == desired_networks.to_a.sort
        if item.like?(temp) && networks_match
          Chef::Log.info("#{resource_name} '#{name}' is up to date")
        else
          Chef::Log.info "Update #{resource_name} '#{name}'"
          Chef::Log.debug "#{resource_name} '#{name}' Chef resource differs from OneView resource."
          Chef::Log.debug "Current state: #{JSON.pretty_generate(item.data)}"
          Chef::Log.debug "Desired state: #{JSON.pretty_generate(temp)}"
          diff = get_diff(item, temp)
          diff << get_diff({ networkUris: retrieved_networks }, networkUris: desired_networks)
          converge_by "Update #{resource_name} '#{name}'#{diff}" do
            temp['networkUris'] = desired_networks
            item.update(temp)
          end
        end
      end

      def create_network_set_if_missing
        item = load_resource_with_properties
        create_if_missing(item)
      end
    end
  end
end
