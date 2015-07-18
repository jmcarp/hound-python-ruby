require "iniparse"

class ConfigOptions
  DEFAULT_CONFIG_FILE = "config/default.ini"

  def load_config(config)
    opts = IniParse.parse(config || "")
    entries = opts["flake8"] || []
    return Hash[entries.collect { |value| [value.key, value.value] }]
  end

  def initialize(config)
    @custom_options = load_config(config)
  end

  def to_hash
    default_options.merge(custom_options)
  end

  private

  attr_reader :custom_options

  def default_options
    @default_config ||= load_config(File.read(DEFAULT_CONFIG_FILE))
  end
end
