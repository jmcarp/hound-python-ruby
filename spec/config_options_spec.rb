require "spec_helper"
require "config_options"

describe ConfigOptions do
  describe "#to_hash" do
    it "returns merged config options as a hash" do
      config_options = ConfigOptions.new(<<-CONFIG)
[flake8]
max-line-length=90
      CONFIG

      options_hash = config_options.to_hash

      expect(options_hash.to_hash).to eq ({"max-line-length" => 90})
    end
  end
end
