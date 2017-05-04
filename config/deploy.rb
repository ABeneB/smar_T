# config valid only for current version of Capistrano
lock "3.7.2"

set :application, "smar_T"
set :repo_url, "git@github.com:nielspetersen/smar_T.git"
set :branch, "master"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads", "vendor/bundle"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Specify of ruby version used by rvm
set :rvm_ruby_version, '2.3.3'

# Passenger configuration
# set :passenger_environment_variables, { :path => '/usr/bin/passenger:$PATH' }
# set :passenger_restart_command, '/usr/bin/passenger-config restart-app'

namespace :deploy do
  namespace :db do
    desc "Load the database schema if needed"
    task load: [:set_rails_env] do
      on primary :db do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, "db:schema:load"
            execute :touch, shared_path.join(".schema_loaded")
          end
        end
      end
    end
  end
end

before "deploy:migrate", "deploy:db:load"
