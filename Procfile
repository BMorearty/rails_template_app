web:           bundle exec thin start -p $PORT -e $RACK_ENV
worker:        env QUEUE=alerts bundle exec rake environment resque:work
