require_relative './../../../spec_helper'

describe 'image_streamer_test_api300::os_build_plan_create' do
  let(:complete_resource_name) { 'image_streamer_os_build_plan' }
  include_context 'chef context'

  let(:base_sdk) { OneviewSDK::ImageStreamer::API300 }

  it 'creates it when it does not exist' do
    expect_any_instance_of(base_sdk::BuildPlan).to receive(:exists?).and_return(false)
    expect_any_instance_of(base_sdk::BuildPlan).to receive(:create).and_return(true)
    expect(real_chef_run).to create_image_streamer_os_build_plan('OSBuildPlan1')
  end

  it 'updates it when it exists but not alike' do
    expect_any_instance_of(base_sdk::BuildPlan).to receive(:exists?).and_return(true)
    expect_any_instance_of(base_sdk::BuildPlan).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::BuildPlan).to receive(:like?).and_return(false)
    expect_any_instance_of(base_sdk::BuildPlan).to receive(:update).and_return(true)
    expect(real_chef_run).to create_image_streamer_os_build_plan('OSBuildPlan1')
  end

  it 'does nothing when it exists and is alike' do
    expect_any_instance_of(base_sdk::BuildPlan).to receive(:exists?).and_return(true)
    expect_any_instance_of(base_sdk::BuildPlan).to receive(:retrieve!).and_return(true)
    expect_any_instance_of(base_sdk::BuildPlan).to receive(:like?).and_return(true)
    expect_any_instance_of(base_sdk::BuildPlan).to_not receive(:update)
    expect_any_instance_of(base_sdk::BuildPlan).to_not receive(:create)
    expect(real_chef_run).to create_image_streamer_os_build_plan('OSBuildPlan1')
  end

  context '#load_build_step' do
    before(:each) do
      allow_any_instance_of(base_sdk::BuildPlan).to receive(:[]).and_call_original
      allow_any_instance_of(base_sdk::PlanScript).to receive(:[]).and_call_original
    end

    let(:build_step_name) do
      [
        { planScriptName: 'PlanScript1', serialNumber: 1 }
      ]
    end

    let(:build_step_uri) do
      [
        { planScriptUri: 'rest/fake/plan-script/', serialNumber: 1 }
      ]
    end

    let(:build_step_wrong) do
      [
        { serialNumber: 1 }
      ]
    end

    it 'loads the specified plan scripts by name and works' do
      allow_any_instance_of(base_sdk::BuildPlan).to receive(:[]).with('buildStep').and_return(build_step_name)
      allow_any_instance_of(base_sdk::PlanScript).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(base_sdk::PlanScript).to receive(:[]).with('uri').and_return('rest/fake-uri')

      # Happy path creation
      expect_any_instance_of(base_sdk::BuildPlan).to receive(:exists?).and_return(false)
      expect_any_instance_of(base_sdk::BuildPlan).to receive(:create).and_return(true)
      expect(real_chef_run).to create_image_streamer_os_build_plan('OSBuildPlan1')

      expect(build_step_name.first).to have_key('planScriptUri')
      expect(build_step_name.first['planScriptUri']).to eq('rest/fake-uri')
    end

    it 'raise error when the plan script does not exist' do
      allow_any_instance_of(base_sdk::BuildPlan).to receive(:[]).with('buildStep').and_return(build_step_name)
      allow_any_instance_of(base_sdk::PlanScript).to receive(:retrieve!).and_return(false)
      expect { real_chef_run }.to raise_error(OneviewSDK::NotFound, /not found/)
    end

    it 'does nothing when the url is specified' do
      allow_any_instance_of(base_sdk::BuildPlan).to receive(:[]).with('buildStep').and_return(build_step_uri)
      expect_any_instance_of(base_sdk::PlanScript).to_not receive(:retrieve!)

      # Happy path creation
      expect_any_instance_of(base_sdk::BuildPlan).to receive(:exists?).and_return(false)
      expect_any_instance_of(base_sdk::BuildPlan).to receive(:create).and_return(true)
      expect(real_chef_run).to create_image_streamer_os_build_plan('OSBuildPlan1')

      expect(build_step_uri.first).to have_key('planScriptUri')
      expect(build_step_uri.first['planScriptUri']).to eq('rest/fake/plan-script/')
    end

    it 'raise error when the plan script is not specified' do
      allow_any_instance_of(base_sdk::BuildPlan).to receive(:[]).with('buildStep').and_return(build_step_wrong)
      expect { real_chef_run }.to raise_error(RuntimeError, /InvalidResourceData/)
    end
  end
end
