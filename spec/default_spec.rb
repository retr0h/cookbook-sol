require "chefspec"

describe "sol::default" do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge "sol::default" }

  describe "ttyS1" do
    it "has proper modes" do
      chef_run.template("/etc/init/ttyS1.conf").should be_owned_by("root", "root")
    end

    it "populates template" do
      chef_run.should create_file_with_content "/etc/init/ttyS1.conf",
        %Q{ttyS1 - getty}
      chef_run.should create_file_with_content "/etc/init/ttyS1.conf",
        %Q{# This service maintains a getty on ttyS1 from the point the system is}
      chef_run.should create_file_with_content "/etc/init/ttyS1.conf",
        %Q{exec /sbin/getty -8 38400 ttyS1}
    end
  end

  describe "grub" do
    it "populates template" do
      chef_run.should create_file_with_content "/etc/default/grub",
        %Q{GRUB_DEFAULT=0}
      chef_run.should create_file_with_content "/etc/default/grub",
        %Q{GRUB_HIDDEN_TIMEOUT=0}
      chef_run.should create_file_with_content "/etc/default/grub",
        %Q{GRUB_HIDDEN_TIMEOUT_QUIET=true}
      chef_run.should create_file_with_content "/etc/default/grub",
        %Q{GRUB_TIMEOUT=10}
      #GRUB_CMDLINE_LINUX="BOOTIF=01-e8-9a-8f-91-a8-9e"
      chef_run.should create_file_with_content "/etc/default/grub",
        %Q{GRUB_CMDLINE_LINUX="text console=tty0 console=ttyS1,115200n8"}
      chef_run.should create_file_with_content "/etc/default/grub",
        %Q{GRUB_SERIAL_COMMAND="serial --speed=38400 --unit=0 --word=8 --parity=no --stop=1"}
    end

    it "executes update-grub" do
      chef_run.should execute_command "update-grub"
    end

    it "flags system to reboot" do
      #chef_run.node.run_state.inspect
    end
  end
end
