require_relative './../../spec_helper'

RSpec.describe OneviewCookbook::ResourceBaseProperties do
  include_context 'shared context'

  describe '#load' do
    before :each do
      @context = {}
      allow(@context).to receive(:property).and_return true
      allow(@context).to receive(:node).and_return('oneview' => { 'save_resource_info' => true })
    end

    it 'creates the :client property' do
      expect(@context).to receive(:property).with(:client, required: true)
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
  end
end

RSpec.describe OneviewCookbook::ResourceBase do
  include_context 'shared context'

  let(:base) do
    (Class.new { include OneviewCookbook::ResourceBase }).new
  end

  describe '#create_or_update' do
    # TODO
  end

  describe '#update' do
    # TODO
  end

  describe '#create_if_missing' do
    # TODO
  end

  describe '#delete' do
    # TODO
  end

  describe '#whyrun_supported?' do
    it 'returns true' do
      expect(base.whyrun_supported?).to eq(true)
    end
  end
end
