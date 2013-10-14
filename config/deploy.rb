set :application, 'sixpointprime'
set :repo_url, 'https://github.com/denniskuczynski/sixpointprime.git'
set :git_https_username, 'denniskuczynski'

set :ssh_options, {
  keys: %w(/Users/denniskuczynski/Documents/keys/palamedes.pem)
}

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/home/ec2-user/sixpointprime'
# set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

load File.expand_path("../recipes/base.rb", __FILE__)
load File.expand_path("../recipes/git.rb", __FILE__)
load File.expand_path("../recipes/munin_node.rb", __FILE__)
load File.expand_path("../recipes/monit.rb", __FILE__)
load File.expand_path("../recipes/mongodb.rb", __FILE__)
load File.expand_path("../recipes/mms_monitoring_agent.rb", __FILE__)

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end