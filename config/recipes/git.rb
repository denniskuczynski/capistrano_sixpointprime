namespace :git do
  desc "Install latest stable release of git"
  task :install do
    on roles(:all) do
      sudo "yum install -y git"
    end
  end
end