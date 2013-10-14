require 'tempfile'

def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  file = Tempfile.new('template')
  File.open(file.path, 'w') do |f|
    f.write ERB.new(erb).result(binding)
  end
  upload! file.path, to
  file.delete
end

namespace :deploy do
  desc "Install everything onto the server"
  #task :install do
  #  run "#{sudo} apt-get -y update"
  #  run "#{sudo} apt-get -y install curl git build-essential"
  #end
end