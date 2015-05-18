require "resque"
require "yaml"
require "scss_lint"

require_relative "review_job"

class ScssReviewJob
  @queue = :scss_review

  def self.perform(attributes)
    # repo_name
    # filename
    # commit_sha
    # patch
    # content
    # default_config?
    # custom_config

    options = YAML.load_file("config/default.yml")
    scss_lint_config = SCSSLint::Config.new(options)
    scss_lint_runner = SCSSLint::Runner.new(scss_lint_config)
    scss_lint_runner.run([attributes["content"]])

    violations = scss_lint_runner.lints.map do |lint|
      { line: lint.location.line, message: lint.description }
    end

    Resque.enqueue(
      ReviewJob,
      repo_name: attributes.fetch("repo_name"),
      filename: attributes.fetch("filename"),
      commit_sha: attributes.fetch("commit_sha"),
      patch: attributes.fetch("patch"),
      violations: violations
    )
  end
end
