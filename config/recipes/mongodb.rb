namespace :mongodb do
  desc "Install latest stable release of mongodb"
  task :install do
    on roles(:all) do
      template "mongodb/mongodb.repo", "/tmp/mongodb.repo"
      sudo "mv /tmp/mongodb.repo /etc/yum.repos.d/mongodb.repo"
      sudo "yum install -y mongo-10gen mongo-10gen-server"
    end
  end

  desc "Update the mongodb configuration file"
  task :setup do
    on roles(:all) do
      template "mongodb/mongod.conf.erb", "/tmp/mongod.conf"
      sudo "mv /tmp/mongod.conf /etc/mongod.conf"
      sudo "chown mongod /etc/mongod.conf"
    end
  end
  after :setup, 'mongodb:restart'
  
  %w[start stop restart].each do |command|
    desc "#{command} munin-node"
    task command do
      on roles(:all) do
        sudo "service mongod #{command}"
      end
    end
  end
end