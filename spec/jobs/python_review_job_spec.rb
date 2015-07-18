require "spec_helper"
require "jobs/python_review_job"

describe PythonReviewJob do
  describe ".perform" do
    context "with default configuration" do
      it "returns violations for unused imports" do
        allow(Resque).to receive("enqueue")

        PythonReviewJob.perform(
          "filename" => "test.py",
          "commit_sha" => "123abc",
          "pull_request_number" => "123",
          "patch" => "test",
          "content" => "import this"
        )

        expect(Resque).to have_received("enqueue").with(
          CompletedFileReviewJob,
          filename: "test.py",
          commit_sha: "123abc",
          pull_request_number: "123",
          patch: "test",
          violations: [
            { line: 1, message: "F401 'this' imported but unused" }
          ]
        )
      end

      it "returns violations for syntax errors" do
        allow(Resque).to receive("enqueue")

        PythonReviewJob.perform(
          "filename" => "test.py",
          "commit_sha" => "123abc",
          "pull_request_number" => "123",
          "patch" => "test",
          "content" => "def foo"
        )

        expect(Resque).to have_received("enqueue").with(
          CompletedFileReviewJob,
          filename: "test.py",
          commit_sha: "123abc",
          pull_request_number: "123",
          patch: "test",
          violations: [
            { line: 1, message: "E901 SyntaxError: invalid syntax" }
          ]
        )
      end
    end
  end
end
