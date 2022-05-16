#!/usr/bin/env bash
exec bundle exec sidekiq start -C $RAILS_ROOT/config/sidekiq.yml;
