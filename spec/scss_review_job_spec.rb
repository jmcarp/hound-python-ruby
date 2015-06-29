require "spec_helper"
require "scss_review_job"

describe ScssReviewJob do
  describe ".perform" do
    context "when double quotes are preferred by default" do
      it "enqueues review job with violations" do
        allow(Resque).to receive("enqueue")

        ScssReviewJob.perform(
          "filename" => "test.scss",
          "commit_sha" => "123abc",
          "pull_request_number" => "123",
          "patch" => "test",
          "content" => ".a { display: 'none'; }\n"
        )

        expect(Resque).to have_received("enqueue").with(
          CompletedFileReviewJob,
          filename: "test.scss",
          commit_sha: "123abc",
          pull_request_number: "123",
          patch: "test",
          violations: [
            { line: 1, message: "Prefer double-quoted strings" }
          ]
        )
      end
    end

    context "when string quotes rule is disabled" do
      it "enqueues review job without violations" do
        allow(Resque).to receive("enqueue")

        ScssReviewJob.perform(
          "filename" => "test.scss",
          "commit_sha" => "123abc",
          "pull_request_number" => "123",
          "patch" => "test",
          "content" => ".a { display: 'none'; }\n",
          "config" => <<-CONFIG
linters:
  StringQuotes:
    enabled: false
    style: double_quotes
          CONFIG
        )

        expect(Resque).to have_received("enqueue").with(
          CompletedFileReviewJob,
          filename: "test.scss",
          commit_sha: "123abc",
          pull_request_number: "123",
          patch: "test",
          violations: []
        )
      end
    end

    context "when file with violations is excluded as an Array" do
      it "enqueues review job without violations" do
        allow(Resque).to receive("enqueue")

        ScssReviewJob.perform(
          "filename" => "test.scss",
          "commit_sha" => "123abc",
          "pull_request_number" => "123",
          "patch" => "test",
          "content" => ".a { display: 'none'; }\n",
          "config" => <<-CONFIG
exclude:
  - "**/test.scss"
          CONFIG
        )

        expect(Resque).to have_received("enqueue").with(
          CompletedFileReviewJob,
          filename: "test.scss",
          commit_sha: "123abc",
          pull_request_number: "123",
          patch: "test",
          violations: []
        )
      end
    end

    context "when file with violations is excluded as a String" do
      it "enqueues review job without violations" do
        allow(Resque).to receive("enqueue")

        ScssReviewJob.perform(
          "filename" => "test.scss",
          "commit_sha" => "123abc",
          "patch" => "test",
          "content" => ".a { display: 'none'; }\n",
          "config" => <<-CONFIG
exclude:
  "**/test.scss"
          CONFIG
        )

        expect(Resque).to have_received("enqueue").with(
          CompletedFileReviewJob,
          filename: "test.scss",
          commit_sha: "123abc",
          patch: "test",
          violations: []
        )
      end
    end
  end
end
