web: bundle exec ruby app.rb -p $PORT
resque: TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 QUEUE=scss bundle exec rake jobs:work
