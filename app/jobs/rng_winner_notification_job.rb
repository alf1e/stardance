# Daily sweep that sends the (one-time-ever, per user) RngWinner notification
# to anyone holding the rng_winner achievement. The achievement itself is
# granted lazily whenever a qualifying user visits /achievements
# (see AchievementsController#index); this job just makes sure holders
# eventually hear about it even if they never happen to load that page again.
class RngWinnerNotificationJob < ApplicationJob
  queue_as :default

  def perform
    User::Achievement.where(achievement_slug: "rng_winner").includes(:user).find_each do |user_achievement|
      user = user_achievement.user
      next if Notifications::RngWinner.exists?(recipient: user)

      Notifications::RngWinner.notify(recipient: user)
    end
  end
end
