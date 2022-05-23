Redis::Objects.redis = Redis.new( host: ENV['REDIS_HOST'], :db => 1)

