require_relative './../../spec_helper'

RSpec.describe OneviewCookbook::ResourceBaseProperties do
  include_context 'shared context'

  describe '#load' do
    before :each do
      @context = {}
      allow(@context).to receive(:property).and_return true
      attributes = {
        'oneview' => {
          'save_resource_info' => true,
          'api_version' => 200,
          'api_variant' => 'C7000'
        }
      }
      allow(@context).to receive(:node).and_return(attributes)
    end

    it 'creates the :client property' do
      expect(@context).to receive(:property).with(:client)
      described_class.load(@context)
    end

    it 'creates the :name property' do
      expect(@context).to receive(:property).with(:name, [String, Symbol], required: true)
      described_class.load(@context)
    end

    it 'creates the :data property' do
      expect(@context).to receive(:property).with(:data, Hash, default: {})
      described_class.load(@context)
    end

    it 'creates the :save_resource_info property' do
      expect(@context).to receive(:property).with(:save_resource_info, [TrueClass, FalseClass, Array], default: true)
      described_class.load(@context)
    end

    it 'creates the :api_version property' do
      expect(@context).to receive(:property).with(:api_version, Integer, default: @context.node['oneview']['api_version'])
      described_class.load(@context)
    end

    it 'creates the :api_variant property' do
      expect(@context).to receive(:property)
        .with(:api_variant, [String, Symbol], default: @context.node['oneview']['api_variant'])
      described_class.load(@context)
    end

    it 'creates the :api_header_version property' do
      expect(@context).to receive(:property).with(:api_header_version, Integer)
      described_class.load(@context)
    end

    it 'creates the :operation property' do
      expect(@context).to receive(:property).with(:operation, String)
      described_class.load(@context)
    end

    it 'creates the :path property' do
      expect(@context).to receive(:property).with(:path, String)
      described_class.load(@context)
    end

    it 'creates the :value property' do
      expect(@context).to receive(:property).with(:value, [String, Array])
      described_class.load(@context)
    end
  end

  describe 'self.safe_dup' do
    it 'dups a dupable object correctly' do
      dupable = 'dupable'.freeze
      expect(described_class.safe_dup(dupable)).to_not be dupable
    end

    it 'returns the same object if not dupable' do
      not_dupable = 1
      expect(described_class.safe_dup(not_dupable)).to be not_dupable
    end
  end
end
