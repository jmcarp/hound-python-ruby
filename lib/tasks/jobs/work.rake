require "config/redis"
require "resque/tasks"

task "resque:setup" do
  ENV["QUEUE"] = "scss_review"
end

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"
