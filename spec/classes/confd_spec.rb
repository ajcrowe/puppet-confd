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
        it { should contain_class('confd::config') }
        
      end
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