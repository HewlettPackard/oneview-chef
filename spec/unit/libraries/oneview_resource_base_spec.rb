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
          'api_module' => 200,
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
      expect(@context).to receive(:property).with(:api_version, Fixnum)
      described_class.load(@context)
    end

    it 'creates the :api_module property' do
      expect(@context).to receive(:property).with(:api_module, Fixnum, default: @context.node['oneview']['api_module'])
      described_class.load(@context)
    end

    it 'creates the :api_variant property' do
      expect(@context).to receive(:property)
        .with(:api_variant, [String, Symbol], default: @context.node['oneview']['api_variant'])
      described_class.load(@context)
    end
  end
end

# Poser class acting like Chef::Provider
class Base
  include OneviewCookbook::ResourceBase
  def converge_by(*)
    yield
  end

  def resource_name
    'oneview_resource'
  end

  def name
    'fake'
  end

  def save_resource_info
    true
  end
end

RSpec.describe OneviewCookbook::ResourceBase do
  include_context 'shared context'

  let(:base) do
    Base.new
  end

  describe '#create_or_update' do
    it 'accepts a resource as a parameter' do
      expect(base).to_not receive(:load_resource)
      expect(@resource).to receive(:exists?).and_raise 'Called exists?'
      expect { base.create_or_update(@resource) }.to raise_error 'Called exists?'
    end

    it 'loads the resource if not passed in as a parameter' do
      expect(base).to receive(:load_resource).and_raise 'Called load_resource'
      expect { base.create_or_update }.to raise_error 'Called load_resource'
    end

    it 'creates the resource if it does not exist' do
      expect(@resource).to receive(:exists?).and_return(false)
      expect(@resource).to receive(:create).and_return(true)
      expect(base).to receive(:save_res_info).and_return(true)
      expect(base.create_or_update(@resource)).to eq(true) # And returns true
    end

    it 'updates the resource if it exists but is not alike' do
      expect(@resource).to receive(:exists?).and_return(true)
      expect(@resource).to receive(:retrieve!).and_return(true)
      expect(@resource).to receive(:like?).and_return(false)
      expect(@resource).to receive(:update).and_return(true)
      expect(base).to receive(:save_res_info).and_return(true)
      expect(base).to receive(:get_diff).and_return('')
      expect(base.create_or_update(@resource)).to eq(false) # And returns false
    end

    it 'does nothing if the resource exists and is alike' do
      expect(@resource).to receive(:exists?).and_return(true)
      expect(@resource).to receive(:retrieve!).and_return(true)
      expect(@resource).to receive(:like?).and_return(true)
      expect(base).to receive(:save_res_info).and_return(true)
      expect(base.create_or_update(@resource)).to eq(false) # And returns true
    end
  end

  describe '#add_or_edit' do
    it 'provides add or edit support' do
      expect(base).to receive(:create_or_update).with(nil, :add, :edit).and_return(true)
      base.add_or_edit
    end
  end

  describe '#create_if_missing' do
    it 'accepts a resource as a parameter' do
      expect(base).to_not receive(:load_resource)
      expect(@resource).to receive(:exists?).and_raise 'Called exists?'
      expect { base.create_if_missing(@resource) }.to raise_error 'Called exists?'
    end

    it 'loads the resource if not passed in as a parameter' do
      expect(base).to receive(:load_resource).and_raise 'Called load_resource'
      expect { base.create_if_missing }.to raise_error 'Called load_resource'
    end

    it 'creates the resource if it does not exist' do
      expect(@resource).to receive(:exists?).and_return(false)
      expect(@resource).to receive(:create).and_return(true)
      expect(base).to receive(:save_res_info).and_return(true)
      expect(base.create_if_missing(@resource)).to eq(true) # And returns true
    end

    it 'retrieves and saves the resource info if it already exists' do
      expect(@resource).to receive(:exists?).and_return(true)
      expect(@resource).to receive(:retrieve!).and_return(true)
      expect(base).to receive(:save_res_info).and_return(true)
      expect(base.create_if_missing(@resource)).to eq(false) # And returns false
    end

    it 'does not retrieve and save the resource info if it exists but save_resource_info is false' do
      expect(@resource).to receive(:exists?).and_return(true)
      expect(base).to receive(:save_resource_info).twice.and_return(false)
      expect(@resource).to_not receive(:retrieve!)
      expect(base).to receive(:save_res_info).with(false, any_args)
      expect(base.create_if_missing(@resource)).to eq(false) # And returns false
    end
  end

  describe '#add_if_missing' do
    it 'provides add if missing support' do
      expect(base).to receive(:create_if_missing).with(nil, :add).and_return(true)
      base.add_if_missing
    end
  end

  describe '#delete' do
    it 'accepts a resource as a parameter' do
      expect(@resource).to receive(:retrieve!).and_return(false)
      base.delete(@resource)
    end

    it 'loads the resource if not passed in as a parameter' do
      expect(base).to receive(:load_resource).and_return(@resource)
      expect(@resource).to receive(:retrieve!).and_return(false)
      base.delete
    end

    it 'deletes the resource if it is sucessfully retrieved' do
      expect(@resource).to receive(:retrieve!).and_return(true)
      expect(@resource).to receive(:delete).and_return(true)
      expect(base.delete(@resource)).to eq(true) # And returns true
    end

    it 'returns false if the resource cannot be retrieved' do
      expect(@resource).to receive(:retrieve!).and_return(false)
      expect(base.delete(@resource)).to eq(false)
    end
  end

  describe 'remove' do
    it 'provides support for remove' do
      expect(base).to receive(:delete).with(nil, :remove).and_return(true)
      base.remove
    end
  end

  describe '#whyrun_supported?' do
    it 'returns true' do
      expect(base.whyrun_supported?).to eq(true)
    end
  end
end
