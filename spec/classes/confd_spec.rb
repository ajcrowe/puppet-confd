require 'spec_helper'

describe 'confd' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "confd class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('confd::params') }
        it { should contain_class('confd::install').that_comes_before('confd::config') }
        it { should contain_class('confd::config').that_notifies('confd::service') }
        it { should contain_class('confd::config') }

        it { should contain_service('confd').with_enable(true) }
        it { should contain_service('confd').with_ensure('running') }

        it { should contain_file('/etc/confd') }
        it { should contain_file('/etc/confd/conf.d') }
        it { should contain_file('/etc/confd/confd.toml') }
        it { should contain_file('/etc/confd/templates') }
        it { should contain_file('/etc/confd/ssl') }

      end
    end
  end

  context "on redhat families" do
    let(:facts) {{ :osfamily => 'Redhat' }}
    it { should contain_file('/usr/bin/confd') }
    it { should contain_file('/etc/init.d/confd') }

    context "with systemd" do
      let(:facts) {{ :osfamily => 'Redhat', :operatingsystemmajrelease => 7 }}
      it { should contain_file('/etc/systemd/system/confd.service') }
    end
  end

  context "on debian families" do
    let(:facts) {{ :osfamily => 'Debian' }}
    it { should contain_file('/usr/local/bin/confd') }
    it { should contain_file('/etc/init.d/confd.conf') }

    context "with systemd" do
      let(:facts) {{ :osfamily => 'Debian', :operatingsystemmajrelease => 7 }}
      it { should contain_file('/etc/systemd/system/confd.service') }
    end
  end

  context 'unsupported operating system' do
    describe 'confd class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('confd') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
