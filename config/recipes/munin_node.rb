namespace :munin_node do
  desc "Install latest stable release of munin-node"
  task :install do
    on roles(:all) do
      sudo "yum install -y munin-node"
    end
  end

  desc "Update the munin-node configuration file"
  task :setup do
    on roles(:all) do
      template "munin-node/munin-node.conf.erb", "/tmp/munin-node.conf"
      sudo "mv /tmp/munin-node.conf /etc/munin/munin-node.conf"
    end
  end
  after :setup, 'munin_node:restart'
  
  %w[start stop restart].each do |command|
    desc "#{command} munin-node"
    task command do
      on roles(:all) do
        sudo "service munin-node #{command}"
      end
    end
  end
end