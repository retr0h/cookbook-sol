require "chefspec"

describe "sol::default" do
  before { Chef::Recipe.any_instance.stub(:include_recipe) }

  describe "custom vendor" do
    before do
      @chef_run = ChefSpec::ChefRunner.new do |node|
        node['dmi'] = {}
        node['dmi']['system'] = {}
        node['dmi']['system']['manufacturer'] = "foo bar"
        node['sol'] = {}
        node['sol']['foo-bar'] = {}
        node['sol']['foo-bar']['grub'] = {}
        node['sol']['foo-bar']['grub']['hidden_timeout'] = "100"
      end
      @chef_run.converge "sol::default"
    end

    it "has custom GRUB_HIDDEN_TIMEOUT" do
      @chef_run.should create_file_with_content "/etc/default/grub",
        %Q{GRUB_HIDDEN_TIMEOUT=100}
    end
  end

  describe "quanta" do
    before do
      @chef_run = ChefSpec::ChefRunner.new do |node|
        node['dmi'] = {}
        node['dmi']['system'] = {}
        node['dmi']['system']['manufacturer'] = "Quanta " # Quanta has a trailing space
      end
      @chef_run.converge "sol::default"
    end

    describe "ttyS1" do
      it "has proper owner" do
        @chef_run.template("/etc/init/ttyS1.conf").should be_owned_by("root", "root")
      end

      it "has proper modes" do
        m = @chef_run.template("/etc/init/ttyS1.conf").mode

        sprintf("%o", m).should == "644"
      end

      it "has getty" do
        @chef_run.should create_file_with_content "/etc/init/ttyS1.conf",
          %Q{ttyS1 - getty}
      end

      it "has comment" do
        @chef_run.should create_file_with_content "/etc/init/ttyS1.conf",
          %Q{# This service maintains a getty on ttyS1 from the point the system is}
      end

      it "has getty exec" do
        @chef_run.should create_file_with_content "/etc/init/ttyS1.conf",
          %Q{exec /sbin/getty -8 38400 ttyS1}
      end
    end

    describe "grub" do
      it "has GRUB_CMDLINE_LINUX" do
        @chef_run.should create_file_with_content "/etc/default/grub",
          %Q{GRUB_CMDLINE_LINUX="text console=tty0 console=ttyS1,115200n8"}
      end

      it "has GRUB_SERIAL_COMMAND" do
        @chef_run.should create_file_with_content "/etc/default/grub",
          %Q{GRUB_SERIAL_COMMAND="serial --speed=38400 --unit=0 --word=8 --parity=no --stop=1"}
      end
    end
  end

  describe "dell" do
    before do
      @chef_run = ChefSpec::ChefRunner.new do |node|
        node['dmi'] = {}
        node['dmi']['system'] = {}
        node['dmi']['system']['manufacturer'] = "Dell Inc."
      end
      @chef_run.converge "sol::default"
    end

    describe "ttyS0" do
      it "has proper owner" do
        @chef_run.template("/etc/init/ttyS0.conf").should be_owned_by("root", "root")
      end

      it "has proper modes" do
        m = @chef_run.template("/etc/init/ttyS0.conf").mode

        sprintf("%o", m).should == "644"
      end
    end

    it "has getty" do
      @chef_run.should create_file_with_content "/etc/init/ttyS0.conf",
        %Q{ttyS0 - getty}
    end

    it "has comment" do
      @chef_run.should create_file_with_content "/etc/init/ttyS0.conf",
        %Q{# This service maintains a getty on ttyS0 from the point the system is}
    end

    it "has getty exec" do
      @chef_run.should create_file_with_content "/etc/init/ttyS0.conf",
        %Q{exec /sbin/getty -8 115200 ttyS0}
    end

    describe "grub" do
      it "has GRUB_CMDLINE_LINUX" do
        @chef_run.should create_file_with_content "/etc/default/grub",
          %Q{GRUB_CMDLINE_LINUX="text console=tty0 console=ttyS0,115200n8"}
      end

      it "has GRUB_SERIAL_COMMAND" do
        @chef_run.should create_file_with_content "/etc/default/grub",
          %Q{GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"}
      end
    end
  end

  describe "defaults" do
    before do
      @chef_run = ChefSpec::ChefRunner.new do |node|
        node['dmi'] = {}
        node['dmi']['system'] = {}
        node['dmi']['system']['manufacturer'] = "default"
      end
      @chef_run.converge "sol::default"
    end

    describe "ttyS1" do
      it "has proper owner" do
        @chef_run.template("/etc/init/ttyS1.conf").should be_owned_by("root", "root")
      end

      it "has proper modes" do
        m = @chef_run.template("/etc/init/ttyS1.conf").mode

        sprintf("%o", m).should == "644"
      end

      it "has getty" do
        @chef_run.should create_file_with_content "/etc/init/ttyS1.conf",
          %Q{ttyS1 - getty}
      end

      it "has comment" do
        @chef_run.should create_file_with_content "/etc/init/ttyS1.conf",
          %Q{# This service maintains a getty on ttyS1 from the point the system is}
      end

      it "has getty exec" do
        @chef_run.should create_file_with_content "/etc/init/ttyS1.conf",
          %Q{exec /sbin/getty -8 38400 ttyS1}
      end
    end

    describe "grub" do
      it "has GRUB_CMDLINE_LINUX" do
        @chef_run.should create_file_with_content "/etc/default/grub",
          %Q{GRUB_CMDLINE_LINUX="text console=tty0 console=ttyS1,115200n8"}
      end

      it "has GRUB_SERIAL_COMMAND" do
        @chef_run.should create_file_with_content "/etc/default/grub",
          %Q{GRUB_SERIAL_COMMAND="serial --speed=38400 --unit=0 --word=8 --parity=no --stop=1"}
      end

      it "has GRUB_DEFAULT" do
        @chef_run.should create_file_with_content "/etc/default/grub",
          %Q{GRUB_DEFAULT=0}
      end

      it "has GRUB_HIDDEN_TIMEOUT" do
        @chef_run.should create_file_with_content "/etc/default/grub",
          %Q{GRUB_HIDDEN_TIMEOUT=0}
      end

      it "has GRUB_HIDDEN_TIMEOUT_QUIET" do
        @chef_run.should create_file_with_content "/etc/default/grub",
          %Q{GRUB_HIDDEN_TIMEOUT_QUIET=true}
      end

      it "has GRUB_TIMEOUT" do
        @chef_run.should create_file_with_content "/etc/default/grub",
          %Q{GRUB_TIMEOUT=10}
      end

      it "executes update-grub" do
        @chef_run.should execute_command "update-grub"
      end

      it "flags system to reboot" do
        #TODO: Still not happy with this
        @chef_run.resources.find{ |r| r.name == 'setting reboot flag' }.old_run_action(:create)

        @chef_run.node.run_state['reboot'].should be_true
      end
    end
  end
end
