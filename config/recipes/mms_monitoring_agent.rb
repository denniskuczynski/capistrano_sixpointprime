namespace :mms_monitoring_agent do

  desc "Install latest stable release of mms_monitoring_agent"
  task :install do
    on roles(:all) do
      sudo "yum -y install python-setuptools build-essential python-dev"
      sudo "easy_install pymongo"
      sudo "wget https://mms.10gen.com/settings/10gen-mms-agent.tar.gz"
      sudo "tar xvf 10gen-mms-agent.tar.gz"
      template "mms_monitoring_agent/start_script.sh", "/tmp/start_script.sh"
      sudo "mv /tmp/start_script.sh /home/ec2-user"
      sudo "chmod +x /home/ec2-user/start_script.sh"
    end
  end

  desc "Setup mms_monitoring_agent configuration for this application"
  task :setup do
    on roles(:all) do
      mms_api_key = ask(:mms_api_key, "Enter MMS API Key:").call
      mms_secret_key = ask(:mms_secret_key, "Enter MMS Secret Key:").call

      sudo :sed, "-i 's/@API_KEY@/#{mms_api_key}/g' /home/ec2-user/mms-agent/settings.py"
      sudo :sed, "-i 's/@SECRET_KEY@/#{mms_secret_key}/g' /home/ec2-user/mms-agent/settings.py"
    end
  end
  after :setup, 'mms_monitoring_agent:start'
  
  desc "start mms_monitoring_agent"
  task :start do
    on roles(:all) do
      # Add a sleep to wait for python to start
      execute "/home/ec2-user/start_script.sh"
    end
  end

  desc "stop mms_monitoring_agent"
  task :stop do
    on roles(:all) do
      sudo "pkill python"
    end
  end

end