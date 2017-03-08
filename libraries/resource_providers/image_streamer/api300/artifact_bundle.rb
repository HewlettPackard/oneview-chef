# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require_relative '../../../resource_provider'

module OneviewCookbook
  module ImageStreamer
    module API300
      # DeploymentPlan Provider resource methods
      class ArtifactBundleProvider < ResourceProvider
        # Call the 'add_<resource_type>' methods for based on the resource_type passed in to allow using names
        # @param [String, Symbol] resource_type Type of resource to be loaded. e.g., :GoldenImage, :FCNetwork.
        # @param [Array] resource_array Array containing the names of the resources and whether they are readonly or not. e.g., [{'DP', false}]
        # @param [String] add_method String containing the name of the method which adds the arrays of resources to the artifact bundle.
        def load_expected_resources(resource_type, resource_array, add_method = nil)
          resource_array.each do |resource|
            puts "\n\n\n\n\n\n\n\nresource: #{resource}"
            resource[:read_only] ||= true
            resource = load_resource(resource_type, resource[:name])
            add_method = 'add_' + resource_type.to_s.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase if add_method.nil?
            @item.method(add_method).call(resource, resource[:read_only])
          end
        end

        def create_if_missing
          load_expected_resources(:BuildPlan, @context.os_build_plans)
          load_expected_resources(:DeploymentPlan, @context.deployment_plans)
          load_expected_resources(:GoldenImage, @context.golden_images)
          load_expected_resources(:PlanScript, @context.plan_scripts)
          super
        end

        def update_name
          raise 'This action requires the new_name field to be specified.' unless @context.new_name
          raise "#{@resource_name} #{@name} does not exist in the appliance. Cannot run update_name action." unless @item.retrieve!
          return Chef::Log.info("#{@resource_name} '#{@name}' is up to date") if @item[:name] == @context.new_name
          new_name_in_use = resource_named(:ArtifactBundle).new(@item.client, name: @context.new_name).exists?
          raise "#{@resource_name} name '#{@context.new_name}' is already in use." if new_name_in_use
          Chef::Log.debug "New name #{@context.new_name} differs from current name'#{@name}' for resource."
          @context.converge_by "Update #{@resource_name}'s name from '#{@name}' to #{@context.new_name} completed successfully" do
            @item.update_name(@context.new_name)
          end
        end

        def download
          raise "#{@resource_name} #{@context.file_path} must be specified for this action" unless @context.file_path
          raise "#{@resource_name} #{@name} does not exist in the appliance. Cannot run download action." unless @item.retrieve!
          return Chef::Log.info("#{@resource_name} '#{@name}' file already exists in specified location.") if File.file?(@context.file_path)
          @context.converge_by "Download #{@resource_name}'s '#{@name}' to #{@context.file_path} completed successfully" do
            @item.download(@context.file_path)
          end
        end

        def upload
          raise "#{@resource_name} '#{@context.file_path}' file does not exist." unless File.file?(@context.file_path)
          return Chef::Log.info("#{@resource_name} #{@name} already exists in the appliance.") if @item.exists?
          @context.converge_by "Upload of #{@resource_name}'s '#{@name}' completed successfully" do
            @item.class.create_from_file(@item.client, @context.file_path, @name)
          end
        end

        def extract
          raise "#{@resource_name} #{@name} does not exist in the appliance. Cannot run extract action." unless @item.exists?
          @context.converge_by "Extract #{@resource_name}'s '#{@name}'completed successfully" do
            @item.extract
          end
        end

        def backup
          deployment_group = load_resource(:DeploymentGroup, @name)
          Chef::Log.info("Starting backup of DeploymentGroup #{@name}...")
          @context.converge_by "Backup operation of DeploymentGroup '#{@name}' completed successfully" do
            @item.class.create_backup(@item.client, deployment_group)
          end
        end

        def backup_from_file
          raise "#{@resource_name} #{@context.file_path} must be specified for this action" unless @context.file_path
          raise "'#{@context.file_path}' file does not exist." unless File.file?(@context.file_path)
          raise 'A deployment_group field is required for this action.' unless @context.deployment_group
          deployment_group = load_resource(:DeploymentGroup, @context.deployment_group)
          Chef::Log.info("Starting upload of backup file #{@context.file_path}...")
          @context.converge_by "Upload of backup file '#{@context.file_path}' completed successfully" do
            return @item.class.create_backup_from_file!(@item.client, deployment_group, @context.file_path, @name) unless @context.timeout
            return @item.class.create_backup_from_file!(@item.client, deployment_group, @context.file_path, @name, @context.timeout)
          end
        end

        def download_backup
          raise "#{@resource_name} #{@context.file_path} must be specified for this action" unless @context.file_path
          return Chef::Log.info("File '#{@context.file_path}' already exists in specified location.") if File.file?(@context.file_path)
          backup = @item.class.get_backups(@item.client).first
          raise 'There are no backups present in the appliance. Cannot run download_backup action.' unless backup
          @context.converge_by "Downloading appliance backup image to '#{@context.file_path}' completed successfully" do
            @item.class.download_backup(@item.client, @context.file_path, backup)
          end
        end

        def extract_backup
          backup = @item.class.get_backups(@item.client).first
          raise 'There are no backups present in the appliance. Cannot run download_backup action.' unless backup
          deployment_group = load_resource(:DeploymentGroup, @name)
          @context.converge_by "Extract backup operation from Deployment Group '#{@name}'completed successfully" do
            @item.class.extract_backup(@item.client, deployment_group, backup)
          end
        end
      end
    end
  end
end
