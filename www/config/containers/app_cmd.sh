#!/usr/bin/env bash
exec bundle exec sidekiq start -C /app/config/sidekiq.yml;
