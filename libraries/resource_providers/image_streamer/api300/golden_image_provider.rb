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

module OneviewCookbook
  module ImageStreamer
    module API300
      # PlanScript Provider resource methods
      class GoldenImageProvider < ResourceProvider
        def load_resources
          @item.set_os_volume(resource_named(:OSVolume).new(@item.client, name: @new_resource.os_volume)) if @new_resource.os_volume
          @item.set_build_plan(resource_named(:BuildPlan).new(@item.client, name: @new_resource.os_build_plan)) if @new_resource.os_build_plan
        end

        def create_or_update
          load_resources
          super
        end

        def create_if_missing
          load_resources
          super
        end

        def upload_if_missing
          raise 'InvalidFilePath: The file_path was not specified. Please set it and try again' unless @new_resource.file_path
          raise "InvalidFilePath: Could not find the file '#{@new_resource.file_path}'" unless File.exist?(@new_resource.file_path)
          return Chef::Log.info("#{@resource_type} '#{@name}' already exist") if @item.exists?
          connection_timeout = @new_resource.timeout || resource_named(:GoldenImage)::READ_TIMEOUT
          Chef::Log.info("Uploading #{@resource_type} '#{@name}' from '#{@new_resource.file_path}'. Timeout is #{connection_timeout} seconds")
          @context.converge_by("Upload #{@resource_type} '#{@name}' from '#{@new_resource.file_path}'") do
            resource_named(:GoldenImage).add(@item.client, @new_resource.file_path, @item.data, connection_timeout)
          end
        end

        def download_validation
          raise 'InvalidFilePath: The file_path was not specified. Please set it and try again' unless @new_resource.file_path
          return Chef::Log.info("#{@resource_type} '#{@name}' file '#{@new_resource.file_path}' already exist") if File.exist?(@new_resource.file_path)
          @item.retrieve! || raise("#{@resource_name} '#{@name}' not found!")
        end

        def download
          download_validation
          connection_timeout = @new_resource.timeout || resource_named(:GoldenImage)::READ_TIMEOUT
          Chef::Log.info("Downloading #{@resource_type} '#{@name}' to '#{@new_resource.file_path}'. Timeout is #{connection_timeout} seconds")
          @context.converge_by("Download #{@resource_type} '#{@name}' to '#{@new_resource.file_path}'") do
            @item.download(@new_resource.file_path, connection_timeout)
          end
        end

        def download_details_archive
          download_validation
          Chef::Log.info("Downloading' #{@resource_type} '#{@name}' details to '#{@new_resource.file_path}'")
          @context.converge_by("Download' #{@resource_type} '#{@name}' details to '#{@new_resource.file_path}'") do
            @item.download_details_archive(@new_resource.file_path)
          end
        end
      end
    end
  end
end
