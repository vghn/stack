# Configure the load path so all dependencies in your Gemfile can be required
require 'bundler/setup'

# Add libraries to the load path
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

# VARs
PROJECT       = 'vpm'
PUPPET_SERVER = 'puppet.ghn.me'

# Include task modules
require 'tasks/release'
Tasks::Release.new
require 'tasks/travisci'
Tasks::TravisCI.new

# Stack SSH commands
namespace :stack do
  desc 'Updates docker compose environment'
  task :update do
    sh "( ssh vlad@#{PUPPET_SERVER} 'docker-compose --project-name #{PROJECT} --file - pull' ) < docker-compose.yml && ( ssh vlad@#{PUPPET_SERVER} 'docker-compose --project-name #{PROJECT} --file - up -d --remove-orphans' ) < docker-compose.yml"
  end
end

# Display version
require 'version'
desc 'Display version'
task :version do
  puts "Current version: #{Version::FULL}"
end

# Create a list of contributors from GitHub
desc 'Populate CONTRIBUTORS file'
task :contributors do
  system("git log --format='%aN' | sort -u > CONTRIBUTORS")
end

# List all tasks by default
Rake::Task[:default].clear if Rake::Task.task_defined?(:default)
task :default do
  system 'rake -D'
end
