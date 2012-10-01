require "chefspec"

describe "raid::megaraid" do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge "raid::megaraid" }
  let(:megacli) { "/usr/local/bin/MegaCli64" }
  let(:adapter) { "0" }

  describe "array" do
    it "clears" do
      chef_run.should execute_command "#{megacli} -cfglddel -lall -a#{adapter}"
    end

    it "creates" do
      command = %Q{#{megacli} -CfgSpanAdd -r10 -Array0[["245:0", "245:1", "245:2", "245:3"]] -Array1[["245:4", "245:5", "245:6", "245:7"]] WB NORA -strpsz64 -a#{adapter}}

      chef_run.should execute_command command
    end

    it "adds spares" do
      command = %Q{#{megacli} -pdhsp -set -physdrv [["245:8", "245:9", "245:10", "245:11"]] -a#{adapter}}

      chef_run.should execute_command command
    end
  end

  describe "disks" do
    it "makes a label" do
      chef_run.should execute_command "parted /dev/sdb --script -- mklabel gpt"
    end

    it "partitions" do
      chef_run.should execute_command "parted /dev/sdb --script -- mkpart primary ext4 1 -1"
    end

    it "creates fs" do
      chef_run.should execute_command "mkfs.ext4 /dev/sdb1"
    end
  end

  describe "pivots /var" do
    it "temporary mount" do
      chef_run.should execute_command "mount /dev/sdb1 /var2"
    end

    it "copies old /var" do
      chef_run.should execute_command "rsync -a /var/* /var2/"
    end
  end
end
