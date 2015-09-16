set :stage, :production
set :branch, 'master'
set :user, 'ec2-user'
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}/"
set :ssh_options, { forward_agent: true }
#
#namespace :deploy do
#  task :symlink_config, roles: :app do
#    run "ln -fs #{shared_path}/config/newrelic.yml #{release_path}/config/newrelic.yml"
#  end
#  after 'deploy:finalize_update', 'deploy:symlink_config'
#
#  task :notify_newrelic, roles: :app do
#    local_user = ENV['USER'] || ENV['USERNAME']
#    run "cd #{current_path} ; bundle exec newrelic deployments -u \"#{local_user}\" -r #{current_revision}"
#  end
#  after 'deploy:restart', 'deploy:notify_newrelic'
#end
namespace :deploy do
  namespace :check do
    task :linked_files => 'config/database.yml'
  end
end
#
#before 'deploy:assets:precompile', 'production_specific_files'
#
#task :production_specific_files, :except => { :no_release => true } do
#  run "cp #{shared_path}/system/database.yml #{release_path}/config/database.yml"
#end


server 'api.trade.gov', roles: %w{web app db}