require "resque"

require "jobs/completed_file_review_job"
require "config_options"

def lint(content, config = {})
  opts = config.to_a.map { |key, value| "--#{key} #{value}" }.join(" ")
  report = `echo "#{content}" | flake8 - #{opts}`
  report.split("\n").map do |line|
    parse_flake8_line(line)
  end
end

def parse_flake8_line(line)
  parts = line.split(":")
  {
    line: parts[1].to_i,
    message: parts.drop(3).join(":").strip
  }
end

class PythonReviewJob
  @queue = :python_review

  def self.perform(attributes)
    # filename
    # commit_sha
    # pull_request_number (pass-through)
    # patch (pass-through)
    # content
    # config

    filename = attributes.fetch("filename")
    violations = lint(attributes["content"])

    Resque.enqueue(
      CompletedFileReviewJob,
      filename: filename,
      commit_sha: attributes.fetch("commit_sha"),
      pull_request_number: attributes.fetch("pull_request_number"),
      patch: attributes.fetch("patch"),
      violations: violations
    )
  end
end
