##
# To properly run chefspec you must comment out the require line from
# reboot-handler's recipes/default.rb.  Chefspec is unable to deal with
# a file installed by another cookbook.
#
# TODO: Investigate this further.

require "chefspec"

describe "sol::default" do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge "sol::default" }

  describe "ttyS1" do
    it "has proper modes" do
      chef_run.template("/etc/init/ttyS1.conf").should be_owned_by("root", "root")
    end

    it "has ttyS1 getty" do
      chef_run.should create_file_with_content "/etc/init/ttyS1.conf",
        %Q{ttyS1 - getty}
    end

    it "has ttyS1 comment" do
      chef_run.should create_file_with_content "/etc/init/ttyS1.conf",
        %Q{# This service maintains a getty on ttyS1 from the point the system is}
    end

    it "has ttyS1 getty exec" do
      chef_run.should create_file_with_content "/etc/init/ttyS1.conf",
        %Q{exec /sbin/getty -8 38400 ttyS1}
    end
  end

  describe "grub" do
    it "has GRUB_DEFAULT" do
      chef_run.should create_file_with_content "/etc/default/grub",
        %Q{GRUB_DEFAULT=0}
    end

    it "has GRUB_HIDDEN_TIMEOUT" do
      chef_run.should create_file_with_content "/etc/default/grub",
        %Q{GRUB_HIDDEN_TIMEOUT=0}
    end

    it "has GRUB_HIDDEN_TIMEOUT_QUIET" do
      chef_run.should create_file_with_content "/etc/default/grub",
        %Q{GRUB_HIDDEN_TIMEOUT_QUIET=true}
    end

    it "has GRUB_TIMEOUT" do
      chef_run.should create_file_with_content "/etc/default/grub",
        %Q{GRUB_TIMEOUT=10}
    end

    it "has GRUB_CMDLINE_LINUX" do
      chef_run.should create_file_with_content "/etc/default/grub",
        %Q{GRUB_CMDLINE_LINUX="text console=tty0 console=ttyS1,115200n8"}
    end

    it "has GRUB_SERIAL_COMMAND" do
      chef_run.should create_file_with_content "/etc/default/grub",
        %Q{GRUB_SERIAL_COMMAND="serial --speed=38400 --unit=0 --word=8 --parity=no --stop=1"}
    end

    it "executes update-grub" do
      chef_run.should execute_command "update-grub"
    end

    it "flags system to reboot" do
      #TODO: Still not happy with this
      chef_run.resources.find{ |r| r.name == 'setting reboot flag' }.old_run_action(:create)

      chef_run.node.run_state['reboot'].should be_true
    end
  end
end
