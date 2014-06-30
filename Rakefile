require 'active_record'
require 'pry'
load "active_record/railties/databases.rake"

seed_loader = Object.new
seed_loader.instance_eval do
  def load_seed
    load "#{ActiveRecord::Tasks::DatabaseTasks.db_dir}/seeds.rb"
  end
end

ActiveRecord::Base.configurations = YAML.load_file(File.join(Rake.application.original_dir, "config", "database.yml"))
ActiveRecord::Base.establish_connection(:development)

ActiveRecord::Tasks::DatabaseTasks.tap do |config|
  config.root                   = Rake.application.original_dir
  config.env                    = "development" # for now
  config.db_dir                 = "db"
  config.migrations_paths       = ["db/migrate"]
  config.fixtures_path          = "test/fixtures"
  config.seed_loader            = seed_loader
  config.database_configuration = ActiveRecord::Base.configurations
end

Rake::Task["db:load_config"].clear
Rake::Task.define_task("db:environment")
Rake::Task["db:test:deprecated"].clear if Rake::Task.task_defined?("db:test:deprecated")
