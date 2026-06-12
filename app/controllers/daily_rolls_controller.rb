# frozen_string_literal: true

# The rng widget and page post here to roll; the leaderboard action renders
# /rng (day-browsable board), and history renders /rng/history (your rolls).
class DailyRollsController < ApplicationController
  before_action :require_week_2_release

  def create
    authorize :daily_roll

    streams = current_user ? roll_for_user : roll_for_anonymous

    respond_to do |format|
      format.turbo_stream { render turbo_stream: streams }
      format.html { redirect_back fallback_location: current_user ? home_path : rng_path }
    end
  end

  # Dev/test only (see routes): wipe today's roll so the reveal can be
  # re-tested without waiting for midnight.
  def clear
    head :not_found and return unless Rails.env.development? || Rails.env.test?
    authorize :daily_roll, :create?

    DailyRoll.where(user: current_user, rolled_on: Date.current).delete_all
    redirect_back fallback_location: rng_path
  end

  PAGE_SIZE = 50

  def leaderboard
    authorize :daily_roll

    @body_class = "app-layout-page"
    @today = Date.current
    @earliest_date = DailyRoll.minimum(:rolled_on) || @today
    @date = requested_date
    @total_count = DailyRoll.on(@date).count
    @total_pages = [ (@total_count.to_f / PAGE_SIZE).ceil, 1 ].max
    @page = params[:page].to_i.clamp(1, @total_pages)
    @offset = (@page - 1) * PAGE_SIZE
    # Only ever loads one page of rows, so a 50k-roll day can't blow up.
    @rolls = DailyRoll.leaderboard(@date, limit: PAGE_SIZE, offset: @offset)

    if current_user
      @viewer_today_roll = DailyRoll.for_today(current_user)
      @viewer_date_roll = @date == @today ? @viewer_today_roll : DailyRoll.find_by(user: current_user, rolled_on: @date)
      if @viewer_date_roll
        @viewer_rank = @viewer_date_roll.rank
        @viewer_page = ((@viewer_rank - 1) / PAGE_SIZE) + 1
      end
    else
      anonymous_roll # memoizes @anonymous_roll for the hero
    end

    record = DailyRoll.order(value: :desc, created_at: :asc).includes(:user).first
    # Today's leader is already on the podium; the record line is only
    # interesting when it points somewhere else.
    @record = record if record && record.rolled_on != @today
  end

  def history
    authorize :daily_roll, :history? # signed in only — no history for guests-of-cookie

    @body_class = "app-layout-page"
    @today = Date.current
    @stats = viewer_stats
    @history = DailyRoll.where(user: current_user).order(rolled_on: :desc).limit(365)
  end

  private

  ANON_COOKIE = :rng_roll

  # Signed-in: one real roll per day, streamed to the rail widget + hero.
  def roll_for_user
    already_rolled = DailyRoll.for_today(current_user).present?
    roll = DailyRoll.roll!(current_user)
    # Whichever surface isn't on the page is a no-op replace by missing id.
    [
      turbo_stream.replace(
        "daily-roll-widget",
        DiscoverRail::DailyRollWidget.new(user: current_user, context: { just_rolled: !already_rolled }).render_in(view_context)
      ),
      turbo_stream.replace(
        "rng-hero",
        partial: "daily_rolls/hero",
        locals: { roll: roll, just_rolled: !already_rolled }
      )
    ]
  end

  # Logged-out: one cookie-backed roll per day (not in the DB, so it never
  # touches the leaderboard). It's claimed onto their account when they sign in
  # (see ApplicationController#claim_anonymous_daily_roll).
  def roll_for_anonymous
    roll = anonymous_roll
    just_rolled = roll.nil?
    if just_rolled
      roll = DailyRoll.new(value: DailyRoll.random_value, rolled_on: Date.current)
      cookies.signed[ANON_COOKIE] = {
        value: "#{roll.value}|#{Date.current.iso8601}",
        expires: 2.days.from_now,
        httponly: true,
        same_site: :lax
      }
    end

    [ turbo_stream.replace("rng-hero", partial: "daily_rolls/hero",
                           locals: { roll: roll, just_rolled: just_rolled, anonymous: true }) ]
  end

  # Today's logged-out roll as an unsaved DailyRoll (so tone/flavor work), or
  # nil. Stored signed so the value can't be forged.
  def anonymous_roll
    return @anonymous_roll if defined?(@anonymous_roll)

    value_s, date_s = cookies.signed[ANON_COOKIE].to_s.split("|", 2)
    @anonymous_roll =
      if date_s == Date.current.iso8601 && value_s.present?
        DailyRoll.new(value: value_s.to_i, rolled_on: Date.current)
      end
  end

  # rng ships with the week 2 release; until then it 404s for everyone.
  def require_week_2_release
    head :not_found unless Flipper.enabled?(:week_2_release, current_user)
  end

  # /rng?date=2026-06-10 — clamped to days that can have rolls.
  def requested_date
    date = Date.iso8601(params[:date].to_s)
    date.clamp(@earliest_date, @today)
  rescue Date::Error
    @today
  end

  def viewer_stats
    rolls = DailyRoll.where(user: current_user)
    best, worst = rolls.order(value: :desc, created_at: :asc).first, rolls.order(value: :asc, created_at: :asc).first
    return nil unless best

    { best: best, worst: worst, count: rolls.count, total: rolls.sum(:value) }
  end
end
