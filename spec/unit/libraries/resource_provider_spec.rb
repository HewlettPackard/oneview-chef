require_relative './../../spec_helper'
require_relative './../../fixtures/fake_resource'

RSpec.describe OneviewCookbook::ResourceProvider do
  include_context 'shared context'

  before :each do
    allow(OneviewCookbook::Helper).to receive(:build_client).and_return @client
    @context = FakeResource.new
  end

  describe '#initialize' do
    it 'sets all the necessary resource info as instance variables' do
      r = described_class.new(@context)
      expect(r.context).to eq(@context)
      expect(r.resource_name).to eq(@context.resource_name)
      expect(r.name).to eq(@context.name)
      expect(r.sdk_resource_type).to eq('Resource')
      expect(r.sdk_api_version).to eq(nil)
      expect(r.sdk_variant).to eq(nil)
      expect(r.item.client).to eq(@client)
      expect(r.item.data).to eq('name' => @context.name)
    end

    it "respects the resource's api_header_version property" do
      r = described_class.new(FakeResource.new(api_header_version: 2))
      expect(r.item.api_version).to eq(2)
    end

    it "respects the resource's data property" do
      data = { 'name' => 'myname', 'key' => 'val' }
      r = described_class.new(FakeResource.new(data: data))
      expect(r.item.data).to eq(data)
    end

    # TODO: Test the other class name cases (3 & 4) in an API module
  end

  describe '#create_or_update' do
    it '' do
      # TODO
    end
  end

  describe '#add_or_edit' do
    it 'calls the create_or_update method with parameters' do
      # TODO
      # create_or_update(:add, :edit)
    end
  end

  describe '#create_if_missing' do
    it '' do
      # TODO
    end
  end

  describe '#add_if_missing' do
    it '' do
      # TODO
    end
  end

  describe '#delete' do
    it '' do
      # TODO
    end
  end

  # Private methods:

  describe '#save_res_info' do
    it '' do
      # TODO
    end
  end

  describe '#convert_keys' do
    it '' do
      # TODO
    end
  end

  describe '#get_diff' do
    it '' do
      # TODO
    end
  end

  describe '#recursive_diff' do
    it '' do
      # TODO
    end
  end
end
