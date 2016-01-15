require 'spec_helper_acceptance'

describe 'confd class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      include ::etcd
      class { 'confd': }
      EOS
      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe service('confd') do
      it { should be_enabled }
      it { should be_running }
    end

  end

  context 'specified etcd parameters' do
    it 'should work with no errors' do
      pp = <<-EOS
      include '::etcd'
      class { 'confd':
        backend     => 'etcd',
        debug       => true,
        nodes  => [ 'http://localhost:4001' ],
        scheme => 'http',
        interval    => 10,
        prefix      => '/test',
      }
      EOS
      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end
  end

  context 'specified consul parameters' do
    it 'should work with no errors' do
      pp = <<-EOS
      include consul
      class { 'confd':
        backend     => 'consul',
        nodes       => ['127.0.0.1:8500'],
        debug       => true,
        interval    => 10,
      }
      EOS
      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end
  end
end

describe 'confd resource define' do

  context 'create resource configuration' do
    it 'should work with no errors' do
      pp = <<-EOS
      confd::resource { 'test_resource':
        dest       => '/tmp/test_resource.ini',
        src        => 'test_template.tmpl',
        keys       => [ '/my/test/key1', '/my/test/key2' ],
        group      => 'root',
        owner      => 'root',
        prefix     => '/test',
        mode       => 0644,
        check_cmd  => 'echo check',
        reload_cmd => 'echo reload'
      }
      EOS
      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end
  end
end
