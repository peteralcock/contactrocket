=begin

require 'server_spec_helper'

describe host('localhost') do
  it { should be_resolvable }
end

describe host('localhost') do
  it { should be_resolvable }
end

describe host('www.localhost') do
  it { should be_resolvable }
end

describe host('crm.localhost') do
  it { should be_resolvable }
end

describe host('auth.localhost') do
  it { should be_resolvable }
end


unless Rails.env.production?

  describe port(5432) do
    it { should be_listening }
  end

  describe port(9200) do
    it { should be_listening }
  end

  describe port(9300) do
    it { should be_listening }
  end

end



  if Rails.env.production? or Rails.env.test?


    describe package('git') do
      it { should be_installed }
    end

    describe port(6379) do
      it { should be_listening }
    end

    describe package('wget') do
      it { should be_installed }
    end

    describe interface('docker0') do
      it { should exist }
    end


    describe interface('eth0') do
      it { should exist }
    end


    describe port(8069) do
      it { should be_listening }
    end


    describe port(8080) do
      it { should be_listening }
    end

    describe port(8001) do
      it { should be_listening }
    end

    describe port(8000) do
      it { should be_listening }
    end


    describe file('/etc/elasticsearch') do
      it { should be_directory }
    end

    describe port(80) do
      it { should be_listening }
    end

    describe file('/opt/odoo') do
      it { should be_directory }
    end

    describe file('/etc/redis') do
      it { should be_directory }
    end

    describe command('ulimit') do
      its(:stdout) { should match /unlimited/ }
      its(:exit_status) { should eq 0 }
    end

    describe command("env x='() { :;}; echo vulnerable' bash -c 'echo this is a test'") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.not_to match(/vulnerable/) }
    end


    describe user('odoo') do
      it { should exist }
    end

    describe file('/contactrocket') do
      it { should exist }
    end



    if Rails.env.production?

      describe group('www-data') do
        it { should exist }
      end

      describe file('/etc/monit') do
        it { should be_directory }
      end

      describe service('monit') do
        it { should be_enabled }
        it { should be_running }
      end


      describe service('apache2') do
        it { should be_enabled }
        it { should be_running }
      end

      describe file('/etc/apache2') do
        it { should be_directory }
      end


      describe file('/var/log/apache2') do
        it { should be_directory }
      end

     describe file('/etc/apache2/sites-available/www.conf') do
       its(:content) { should match /ServerName www.localhost/ }
     end
    
     describe file('/etc/apache2/sites-available/crm.conf') do
       its(:content) { should match /ServerName crm.localhost/ }
       its(:content) { should match /ProxyPass/ }
     end

end
      
  end


=end

