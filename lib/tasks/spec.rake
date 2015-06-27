if ENV["RACK_ENV"] == "development" || ENV["RACK_ENV"] == "test"
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new :spec do |task|
    task.pattern = Dir["spec/**/*_spec.rb"]
  end

  task default: :spec
end
