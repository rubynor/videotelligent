class CreateView < ActiveRecord::Migration
  def up

    create_table :params do |t|
      t.date :last_week
    end

    Param.create(last_week: 1.week.ago.to_date)

    self.connection.execute %Q( CREATE MATERIALIZED VIEW videos_by_views AS
      SELECT video_id, gender, age_group, country, SUM(number_of_views),
        COALESCE(SUM(CASE WHEN on_date >= params.last_week THEN number_of_views END), 0) AS filtered_views_last_week,
        SUM(CASE WHEN on_date >= '#{Date.new(2000)}' THEN number_of_views END) AS filtered_views
      FROM view_stats, params
      GROUP BY gender, age_group, country, video_id
    )

    self.connection.execute %Q( CREATE UNIQUE INDEX videos_by_views_grouped
      ON videos_by_views(video_id, gender, age_group, country);
    )
  end

  def down
    self.connection.execute "DROP MATERIALIZED VIEW IF EXISTS videos_by_views"

    drop_table :params
  end
end
