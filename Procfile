web:           bundle exec unicorn -p $PORT -c ./config/unicorn/unicorn_$RACK_ENV.rb
worker:        env QUEUE=alerts bundle exec rake environment resque:work
