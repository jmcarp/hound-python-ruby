$: << File.expand_path(".")

ENV["RACK_ENV"] = "test"
ENV["REDISTOGO_URL"] = "http://example.com/redistogo"

require "byebug"
