module Opscode
  #  Oneview Resources base actions
  module OneviewResourceBase
    # Create a OneView resource or update it if exists
    # @return [TrueClass, FalseClass] Returns true if the resource was created, false if updated
    def create_or_update
      item = load_resource
      temp = item.data.clone
      if item.exists?
        item.retrieve!
        if item.like? temp
          Chef::Log.info("#{resource_name} '#{name}' is up to date")
        else
          Chef::Log.info "#{resource_name} '#{name}' Chef resource differs from OneView resource."
          Chef::Log.info "Update #{resource_name} '#{name}'"
          converge_by "Update #{resource_name} '#{name}'" do
            item.update(temp) # Note: Assumes resources supports #update
          end
          false
        end
      else
        Chef::Log.info "Create #{resource_name} '#{name}'"
        converge_by "Create #{resource_name} '#{name}'" do
          item.create
        end
        true
      end
    end

    # Create a OneView resource only if doesn't exists
    # @return [TrueClass, FalseClass] Returns true if the resource was created
    def create_if_missing
      item = load_resource
      if item.exists?
        Chef::Log.info("'#{resource_name} #{name}' exists. Skipping")
        item.retrieve!
        false
      else
        Chef::Log.info "Create #{resource_name} '#{name}'"
        converge_by "Create #{resource_name} '#{name}'" do
          item.create
        end
        true
      end
    end

    # Delete a OneView resource
    def delete
      item = load_resource
      converge_by "Delete #{resource_name} '#{name}'" do
        item.retrieve!
        item.delete
      end
    end
  end
end
