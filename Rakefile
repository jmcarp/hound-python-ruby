ENV["RACK_ENV"] ||= "development"

require_relative "scss_review_job"
require_relative "completed_file_review_job"

if ENV["REDIS_URL"]
  uri = URI.parse(ENV["REDIS_URL"])
  REDIS = Redis.new(
    host: uri.host,
    port: uri.port,
    password: uri.password
  )
  Resque.redis = REDIS
end

require "resque/tasks"

task "resque:setup" do
  ENV["QUEUE"] = "scss_review"
end

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"

if ENV["RACK_ENV"] == "development" || ENV["RACK_ENV"] == "test"
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new :specs do |task|
    task.pattern = Dir['spec/**/*_spec.rb']
  end

  task :default => ["specs"]
end
