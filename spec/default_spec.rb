require "chefspec"

describe "raid::default" do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge "raid::default" }

  it "mounts" do
    pending "TODO: how to test this properly"
    #mount "/var" do
    #  device node['raid']['block_device']
    #  fstype node['raid']['fs']

    #  action :enable
    #end
  end
end
