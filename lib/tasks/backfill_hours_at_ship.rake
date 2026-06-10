# dry run:  bin/rails backfill:hours_at_ship
# to apply: bin/rails backfill:hours_at_ship DRY_RUN=false

namespace :backfill do
  desc "Backfill hours_at_ship on existing post_ship_events"
  task hours_at_ship: :environment do
    dry_run = ENV.fetch("DRY_RUN", "true") != "false"

    puts dry_run ? "[DRY RUN] No changes will be written." : "Writing changes to the database."
    puts

    count = Post::ShipEvent.where(hours_at_ship: nil).count

    if count.zero?
      puts "No post_ship_events need backfilling."
      next
    end

    puts "#{dry_run ? 'Would backfill' : 'Backfilling'} #{count} post_ship_event(s)."

    unless dry_run
      ActiveRecord::Base.connection.execute(<<~SQL)
        UPDATE post_ship_events
        SET hours_at_ship = (
          SELECT COALESCE(SUM(post_devlogs.duration_seconds), 0) / 3600.0
          FROM posts devlog_posts
          INNER JOIN post_devlogs ON post_devlogs.id = devlog_posts.postable_id
          WHERE devlog_posts.postable_type = 'Post::Devlog'
            AND devlog_posts.project_id = ship_posts.project_id
            AND post_devlogs.deleted_at IS NULL
            AND devlog_posts.created_at <= ship_posts.created_at
            AND devlog_posts.created_at >= COALESCE(
              (
                SELECT MAX(prev_ship_posts.created_at)
                FROM posts prev_ship_posts
                WHERE prev_ship_posts.postable_type = 'Post::ShipEvent'
                  AND prev_ship_posts.project_id = ship_posts.project_id
                  AND prev_ship_posts.created_at < ship_posts.created_at
              ),
              (SELECT projects.created_at FROM projects WHERE projects.id = ship_posts.project_id)
            )
        )
        FROM posts ship_posts
        WHERE ship_posts.postable_type = 'Post::ShipEvent'
          AND ship_posts.postable_id = post_ship_events.id
          AND post_ship_events.hours_at_ship IS NULL
      SQL
    end

    puts
    puts "#{dry_run ? 'Would backfill' : 'Backfilled'} #{count} post_ship_event(s)."
    puts "Run with DRY_RUN=false to apply." if dry_run
  end
end
