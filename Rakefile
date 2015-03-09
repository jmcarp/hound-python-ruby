require "./app.rb"
require "resque/tasks"

task "resque:setup" do
  ENV["QUEUE"] = "scss"
end

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"
