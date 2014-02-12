# encoding: UTF-8

require_relative 'spec_helper'

describe 'sol::default' do
  before { Chef::Recipe.any_instance.stub(:include_recipe) }
  let(:runner) do
    ChefSpec::Runner.new do |node|
      node.set['dmi']['system']['manufacturer'] = 'foo bar'
      node.set['sol']['foo-bar']['grub']['hidden_timeout'] = '100'
    end
  end
  let(:node) { runner.node }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:grub_file) { chef_run.template '/etc/default/grub' }

  context 'quanta vendor' do
    before do
      # Quanta has a trailing space
      node.set['dmi']['system']['manufacturer'] = 'Quanta '
    end

    describe 'ttyS1' do
      let(:file) { chef_run.template '/etc/init/ttyS1.conf' }

      it 'has proper owner' do
        expect(file.owner).to eq 'root'
        expect(file.group).to eq 'root'
      end

      it 'has proper modes' do
        expect(sprintf('%o', file.mode)).to eq '644'
      end

      it 'has getty' do
        expect(chef_run).to render_file(file.name)
          .with_content %Q{ttyS1 - getty}
      end

      it 'has comment' do
        expect(chef_run).to render_file(file.name)
          .with_content %Q{# This service maintains a getty on ttyS1}
      end

      it 'has getty exec' do
        expect(chef_run).to render_file(file.name)
          .with_content %Q{exec /sbin/getty -8 115200 ttyS1}
      end
    end

    describe 'grub' do
      it 'has GRUB_CMDLINE_LINUX' do
        expect(chef_run).to render_file(grub_file.name)
          .with_content %Q{GRUB_CMDLINE_LINUX="text console=tty0 console=ttyS1,115200n8"} # rubocop:disable LineLength
      end

      it 'has GRUB_SERIAL_COMMAND' do
        expect(chef_run).to render_file(grub_file.name)
          .with_content %Q{GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"} # rubocop:disable LineLength
      end
    end
  end

  context 'dell vendor' do
    before do
      node.set['dmi']['system']['manufacturer'] = 'Dell Inc.'
    end

    describe 'ttyS0' do
      let(:file) { chef_run.template '/etc/init/ttyS0.conf' }

      it 'has proper owner' do
        expect(file.owner).to eq 'root'
        expect(file.group).to eq 'root'
      end

      it 'has proper modes' do
        expect(sprintf('%o', file.mode)).to eq '644'
      end

      it 'has getty' do
        expect(chef_run).to render_file(file.name)
          .with_content %Q{ttyS0 - getty}
      end

      it 'has comment' do
        expect(chef_run).to render_file(file.name)
          .with_content %Q{# This service maintains a getty on ttyS0}
      end

      it 'has getty exec' do
        expect(chef_run).to render_file(file.name)
          .with_content %Q{exec /sbin/getty -8 115200 ttyS0}
      end
    end

    describe 'grub' do
      it 'has GRUB_CMDLINE_LINUX' do
        expect(chef_run).to render_file(grub_file.name)
          .with_content %Q{GRUB_CMDLINE_LINUX="text console=tty0 console=ttyS0,115200n8"} # rubocop:disable LineLength
      end

      it 'has GRUB_SERIAL_COMMAND' do
        expect(chef_run).to render_file(grub_file.name)
          .with_content %Q{GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"} # rubocop:disable LineLength
      end
    end
  end

  context 'default' do
    before do
      node.set['dmi']['system']['manufacturer'] = 'default'
    end

    describe 'ttyS1' do
      let(:file) { chef_run.template '/etc/init/ttyS1.conf' }

      it 'has proper owner' do
        expect(file.owner).to eq 'root'
        expect(file.group).to eq 'root'
      end

      it 'has proper modes' do
        expect(sprintf('%o', file.mode)).to eq '644'
      end

      it 'has getty' do
        expect(chef_run).to render_file(file.name)
          .with_content %Q{ttyS1 - getty}
      end

      it 'has comment' do
        expect(chef_run).to render_file(file.name)
          .with_content %Q{# This service maintains a getty on ttyS1}
      end

      it 'has getty exec' do
        expect(chef_run).to render_file(file.name)
          .with_content %Q{exec /sbin/getty -8 38400 ttyS1}
      end
    end

    describe 'grub' do
      it 'has GRUB_CMDLINE_LINUX' do
        expect(chef_run).to render_file(grub_file.name)
          .with_content %Q{GRUB_CMDLINE_LINUX="text console=tty0 console=ttyS1,115200n8"} # rubocop:disable LineLength
      end

      it 'has GRUB_SERIAL_COMMAND' do
        expect(chef_run).to render_file(grub_file.name)
          .with_content %Q{GRUB_SERIAL_COMMAND="serial --speed=38400 --unit=0 --word=8 --parity=no --stop=1"} # rubocop:disable LineLength
      end

      it 'has GRUB_DEFAULT' do
        expect(chef_run).to render_file(grub_file.name)
          .with_content %Q{GRUB_DEFAULT=0}
      end

      it 'has GRUB_HIDDEN_TIMEOUT' do
        expect(chef_run).to render_file(grub_file.name)
          .with_content %Q{GRUB_HIDDEN_TIMEOUT=0}
      end

      it 'has GRUB_HIDDEN_TIMEOUT_QUIET' do
        expect(chef_run).to render_file(grub_file.name)
          .with_content %Q{GRUB_HIDDEN_TIMEOUT_QUIET=true}
      end

      it 'has GRUB_TIMEOUT' do
        expect(chef_run).to render_file(grub_file.name)
          .with_content %Q{GRUB_TIMEOUT=10}
      end

      it 'notifies' do
        expect(grub_file).to notify('execute[update-grub]').to(:run)
      end
    end
  end

  describe 'ruby block' do
    it "doesn't create" do
      expect(chef_run).not_to run_ruby_block 'setting reboot flag'
    end

    it 'flags system to reboot' do
      chef_run.find_resource('ruby_block', 'setting reboot flag')
        .old_run_action(:create)
      expect(chef_run.node.run_state['reboot']).to be
    end
  end

  describe 'executes' do
    it "doesn't update-grub" do
      expect(chef_run).not_to run_execute 'update-grub'
    end

    it 'notifies' do
      resource = chef_run.execute('update-grub')

      expect(resource).to notify('ruby_block[setting reboot flag]').to(:create)
    end
  end
end
