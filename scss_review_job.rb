require "resque"

class ScssReviewJob
  @queue = :scss_review

  def self.perform(attributes)
    # repo_name
    # filename
    # commit_sha
    # patch
    # content
    # default_config
    # custom_config

    Resque.enqueue(
      ReviewJob,
      repo_name: attributes.fetch(:repo_name),
      filename: attributes.fetch(:filename),
      commit_sha: attributes.fetch(:commit_sha),
      violations: [
        # { line: nil, message: "" }
      ]
    )
  end
end
