require_relative "test_helper"
require_relative "../scss_review_job"

describe ScssReviewJob do
  it "does something" do
    allow(Resque).to receive("enqueue")

    ScssReviewJob.perform(
      "repo_name" => "test",
      "filename" => "test",
      "commit_sha" => "test",
      "patch" => "test"
    )

    expect(Resque).to have_received("enqueue")
  end
end
