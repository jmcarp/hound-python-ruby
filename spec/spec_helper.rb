$: << File.expand_path(".")

ENV["RACK_ENV"] = "test"
ENV["REDIS_URL"] = "redis://rediswoohoo:abc123@example.com:12345/"

require "byebug"
