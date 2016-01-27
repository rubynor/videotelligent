class VideosByView < ActiveRecord::Base
  self.table_name = 'videos_by_views'

  belongs_to :video

  def readonly?
    true
  end

  def self.refresh
    ActiveRecord::Base.connection.execute('REFRESH MATERIALIZED VIEW CONCURRENTLY videos_by_views')
  end
end
