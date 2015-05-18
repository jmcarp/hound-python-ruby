require_relative "spec_helper"
require_relative "../scss_review_job"

describe ScssReviewJob do
  describe ".perform" do
    context "when double quotes are preferred" do
      it "enqueues review job with violations" do
        allow(Resque).to receive("enqueue")

        ScssReviewJob.perform(
          "repo_name" => "jimtom/test",
          "filename" => "test.scss",
          "commit_sha" => "123abc",
          "patch" => "test",
          "content" => ".a { display: 'none'; }\n"
        )

        expect(Resque).to have_received("enqueue").with(
          ReviewJob,
          repo_name: "jimtom/test",
          filename: "test.scss",
          commit_sha: "123abc",
          patch: "test",
          violations: [
            { line: 1, message: "Prefer double-quoted strings" }
          ]
        )
      end
    end
  end
end
