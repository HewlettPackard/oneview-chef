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
      # PlanScript Provider resource methods
      class GoldenImageProvider < ResourceProvider
        def load_resources
          @item.set_os_volume(resource_named(:OSVolume).new(@item.client, name: @context.os_volume)) if @context.os_volume
          @item.set_build_plan(resource_named(:BuildPlan).new(@item.client, name: @context.os_build_plan)) if @context.os_build_plan
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
          raise 'InvalidFilePath: The file_path was not specified. Please set it and try again' unless @context.file_path
          raise "InvalidFilePath: Could not find the file '#{@context.file_path}'" unless File.exist?(@context.file_path)
          return Chef::Log.info("#{@resource_type} '#{@name}' already exist") if @item.exists?
          connection_timeout = @context.timeout || resource_named(:GoldenImage)::READ_TIMEOUT
          @context.converge_by("Uploading' #{@resource_type} '#{@name}' from '#{@context.file_path}'. Timeout is #{connection_timeout} seconds") do
            resource_named(:GoldenImage).add(@item.client, @context.file_path, @item.data, connection_timeout)
          end
        end

        def download_validation
          raise 'InvalidFilePath: The file_path was not specified. Please set it and try again' unless @context.file_path
          return Chef::Log.info("#{@resource_type} '#{@name}' file '#{@context.file_path}' already exist") if File.exist?(@context.file_path)
          raise "ResourceNotFound: #{@resource_type} '#{@name}' could not be found" unless @item.retrieve!
        end

        def download
          download_validation
          connection_timeout = @context.timeout || resource_named(:GoldenImage)::READ_TIMEOUT
          @context.converge_by("Downloading' #{@resource_type} '#{@name}' to '#{@context.file_path}'. Timeout is #{connection_timeout} seconds") do
            @item.download(@context.file_path, connection_timeout)
          end
        end

        def download_details_archive
          download_validation
          @context.converge_by("Downloading' #{@resource_type} '#{@name}' details to '#{@context.file_path}'") do
            @item.download_details_archive(@context.file_path)
          end
        end
      end
    end
  end
end
