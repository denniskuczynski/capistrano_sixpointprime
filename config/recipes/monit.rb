namespace :monit do
  desc "Install latest stable release of monit"
  task :install do
    on roles(:all) do
      sudo "yum install -y monit"
    end
  end

  desc "Update the monit configuration file"
  task :setup do
    on roles(:all) do
      template "monit/monit.conf.erb", "/tmp/monit.conf"
      sudo "mv /tmp/monit.conf /etc/monit.conf"
      sudo "chown root /etc/monit.conf"
      sudo "chmod 600 /etc/monit.conf"
    end
  end
  after :setup, 'monit:restart'
  
  %w[start stop restart].each do |command|
    desc "#{command} monit"
    task command do
      on roles(:all) do
        sudo "service monit #{command}"
      end
    end
  end
end