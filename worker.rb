require "scss_lint"
require "resque"
require "yaml"

class ReviewJob
  @queue = :review
end

module Worker
  @queue = :scss

  def self.perform(params)
    filename = params.fetch(:filename)
    content = params.fetch(:content)
    build_id = params.fetch(:build_id)

    config_options = YAML.load(params.fetch(:custom_config).to_s) ||
      YAML.load(params.fetch(:default_config))
    scss_lint_config = SCSSLint::Config.new(config_options.to_hash)
    runner = SCSSLint::Runner.new(scss_lint_config)

    violations = if scss_lint_config.excluded_file?(filename)
      []
    else
      runner.run([content])
      runner.lints.map do |violation|
        {
          line: violation.line,
          violation: violation.comment
        }
      end
    end

    Resque.enqueue(
      ReviewJob,
      build_id: build_id,
      filename: filename,
      content: content,
      violations: violations
    )
  rescue => exception
    Resque.enqueue(
      FailedReviewJob,
      build_id: build_id,
      filename: filename,
      error: exception.message
    )
  end
end
