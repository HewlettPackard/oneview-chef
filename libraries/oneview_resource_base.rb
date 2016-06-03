module Opscode
  # Define default properties for all resources
  module OneviewResourceBaseProperties
    # Loads the default properties for all resources
    def self.load(context)
      context.property :client, required: true
      context.property :name, [String, Symbol], required: true
      context.property :data, Hash, default: {}
      context.property :save_resource_info, [TrueClass, FalseClass, Array], default: context.node['oneview']['save_resource_info']
    end
  end

  #  Oneview Resources base actions
  module OneviewResourceBase
    # Create a OneView resource or update it if exists
    # @param [OneviewSDK::Resource] item item to be created or updated
    # @return [TrueClass, FalseClass] Returns true if the resource was created, false if updated
    def create_or_update(item = nil)
      item ||= load_resource
      klass_name = 'OneView ' + item.class.name.split('::').last
      temp = item.data.clone
      if item.exists?
        item.retrieve!
        if item.like? temp
          Chef::Log.info("#{klass_name} '#{name}' is up to date")
        else
          Chef::Log.debug "#{klass_name} '#{name}' Chef resource differs from OneView resource."
          Chef::Log.info "Update #{klass_name} '#{name}'"
          converge_by "Update #{klass_name} '#{name}'" do
            item.update(temp) # Note: Assumes resources supports #update
          end
          false
        end
      else
        Chef::Log.info "Create #{klass_name} '#{name}'"
        converge_by "Create #{klass_name} '#{name}'" do
          item.create
        end
        true
      end
      save_res_info(save_resource_info, name, item.data)
    end

    # Update a OneView resource or update it if exists
    # @param [OneviewSDK::Resource] item item to be updated
    # @return [TrueClass, FalseClass] Returns true if the resource was updated, false if not found
    def update(item = nil)
      item ||= load_resource
      klass_name = 'OneView ' + item.class.name.split('::').last
      temp = item.data.clone
      if item.exists?
        item.retrieve!
        converge_by "Update #{klass_name} '#{name}'" do
          item.update(temp) # Note: Assumes resources supports #update
        end
        save_res_info(save_resource_info, name, item.data)
        true
      else
        false
      end
    end


    # Create a OneView resource only if doesn't exists
    # @param [OneviewSDK::Resource] item item to be deleted
    # @return [TrueClass, FalseClass] Returns true if the resource was created
    def create_if_missing(item = nil)
      item ||= load_resource
      if item.exists?
        Chef::Log.info("'#{resource_name} #{name}' exists. Skipping")
        item.retrieve! if save_resource_info
        false
      else
        Chef::Log.info "Create #{resource_name} '#{name}'"
        converge_by "Create #{resource_name} '#{name}'" do
          item.create
        end
        true
      end
      save_res_info(save_resource_info, name, item.data)
    end

    # Delete a OneView resource
    def delete(item = nil)
      item ||= load_resource
      return unless item.retrieve!
      converge_by "Delete #{resource_name} '#{name}'" do
        item.delete
      end
    end

    # Let Chef know that the why-run flag is supported
    def whyrun_supported?
      true
    end
  end
end
