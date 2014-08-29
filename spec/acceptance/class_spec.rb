require 'spec_helper_acceptance'

describe 'confd class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'confd': }
      EOS
      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end
  end

  context 'specified etcd parameters' do
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'confd':
        backend     => 'etcd',
        debug       => true,
        etcd_nodes  => [ 'http://localhost:4001' ],
        etcd_scheme => 'http',
        interval    => 10,
        prefix      => '/test',
        quiet       => false,
        verbose     => true
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
      class { 'confd':
        backend     => 'consul',
        consul      => true,
        consul_addr => '127.0.0.1:8500',
        debug       => true,
        interval    => 10,
        quiet       => false,
        verbose     => true
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

