# Configure the load path so all dependencies in your Gemfile can be required
require 'bundler/setup'

# Include task modules
require 'vtasks/release'
Vtasks::Release.new(
  write_changelog: true,
  wait_for_ci_success: true,
  bug_labels: 'Type: Bug',
  enhancement_labels: 'Type: Enhancement'
)
require 'vtasks/travisci'
Vtasks::TravisCI.new

# Stack SSH commands
namespace :stack do
  namespace :update do
    desc 'Updates MONITOR stack'
    task :monitor do
      sh 'ENVTYPE=production bin/stack deploy monitor'
    end
    desc 'Updates VPM stack'
    task :vpm do
      sh 'ENVTYPE=production bin/stack deploy vpm'
    end
  end
  desc 'Encrypts .env'
  task :env do
    sh 'echo "$TRAVIS_KEY_STACK" | gpg --symmetric --passphrase-fd 0 --batch --yes --cipher-algo AES256 --s2k-digest-algo SHA512 --output .env.gpg .env'
  end
end

# Display version
desc 'Display version'
task :version do
  require 'vtasks/version'
  include Vtasks::Utils::Semver
  puts "Current version: #{gitver}"
end

# Create a list of contributors from GitHub
desc 'Populate CONTRIBUTORS file'
task :contributors do
  system("git log --format='%aN' | sort -u > CONTRIBUTORS")
end

# List all tasks by default
Rake::Task[:default].clear if Rake::Task.task_defined?(:default)
task :default do
  system 'rake -T'
end
