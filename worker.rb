require "scss_lint"
require "resque"
require "yaml"

class ReviewJob
  @queue = :review
end

module Worker
  @queue = :scss

  def self.perform(params)
    config_options = YAML.load(params.fetch(:custom_config).to_s) ||
      YAML.load(params.fetch(:default_config))
    scss_lint_config = SCSSLint::Config.new(config_options.to_hash)

    runner = SCSSLint::Runner.new(scss_lint_config)

    violations = if merged_config.excluded_file?(params.fetch(:filename))
      []
    else
      runner.run([params.fetch(:content)])
      runner.lints.map do |violation|
        {
          line: violation.line,
          violation: violation.comment
        }
      end
    end

    Resque.enqueue(
      ReviewJob,
      build_id: params.fetch(:build_id),
      pull_request_id: params.fetch(:pull_request_id),
      commit: params.fetch(:commit),
      filename: params.fetch(:filename),
      content: params.fetch(:content),
      violations: violations
    )
  end
end
