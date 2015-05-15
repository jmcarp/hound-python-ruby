ENV["RACK_ENV"] = "test"
ENV["REDISTOGO_URL"] = "http://example.com/redistogo"

RSpec.configure do |config|
  # include Rack::Test::Methods
end
