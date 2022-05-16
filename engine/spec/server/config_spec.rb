

 # describe command('ulimit') do
 #   its(:stdout) { should match /unlimited/ }
 #   its(:exit_status) { should eq 0 }
 # end


 # describe service('monit') do
 #   it { should be_enabled }
 #   it { should be_running }
 # end


  # describe service('redis-server') do
  #   it { should be_enabled }
  #   it { should be_running }
  # end




  describe host('your-server.net') do
    it { should be_resolvable }
  end


  describe host('www.your-server.net') do
    it { should be_resolvable }
  end


  describe host('crm.your-server.net') do
    it { should be_resolvable }
  end


#  describe file('/var/engine/shared') do
#    it { should be_directory }
#  end

 


