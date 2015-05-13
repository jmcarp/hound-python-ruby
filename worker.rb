# require "scss_lint"
# require "resque"
# require "yaml"

# class ScssWorker
#   class ReviewJob
#     @queue = :high
#   end

#   class FailedReviewJob
#     @queue = :high
#   end

#   def self.perform(params)
#     repo_name = params.fetch(:repo_name)
#     filename = params.fetch(:filename)
#     content = params.fetch(:content)
#     commit_sha = params.fetch(:commit_sha)

#     config_options = YAML.load(params.fetch(:custom_config).to_s) ||
#       YAML.load(params.fetch(:default_config))
#     scss_lint_config = SCSSLint::Config.new(config_options.to_hash)
#     runner = SCSSLint::Runner.new(scss_lint_config)

#     violations = if scss_lint_config.excluded_file?(filename)
#       []
#     else
#       runner.run([content])
#       runner.lints.map do |violation|
#         {
#           line: violation.line,
#           message: violation.comment
#         }
#       end
#     end

#     Resque.enqueue(
#       ReviewJob,
#       repo_name: repo_name,
#       filename: filename,
#       patch: params.fetch(:patch),
#       commit_sha: commit_sha,
#       # content: content,
#       violations: violations
#     )
#   rescue => exception
#     Resque.enqueue(
#       FailedReviewJob,
#       repo_name: repo_name,
#       filename: filename,
#       commit_sha: commit_sha,
#       error: exception.message
#     )
#   end
# end
