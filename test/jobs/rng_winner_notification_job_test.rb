require "test_helper"

class RngWinnerNotificationJobTest < ActiveSupport::TestCase
  setup do
    @user = create_user(slack_id: "U_RNG_JOB", display_name: "rng_job_user")
  end

  test "notifies a user holding the rng_winner achievement" do
    @user.award_achievement!(:rng_winner, notified: true)

    assert_difference -> { Notifications::RngWinner.count }, 1 do
      RngWinnerNotificationJob.perform_now
    end

    notification = Notifications::RngWinner.last
    assert_equal @user.id, notification.recipient_id
  end

  test "does not notify a user without the achievement" do
    assert_no_difference -> { Notifications::RngWinner.count } do
      RngWinnerNotificationJob.perform_now
    end
  end

  test "does not notify the same user twice across runs" do
    @user.award_achievement!(:rng_winner, notified: true)

    assert_difference -> { Notifications::RngWinner.count }, 1 do
      RngWinnerNotificationJob.perform_now
      RngWinnerNotificationJob.perform_now
    end
  end
end
