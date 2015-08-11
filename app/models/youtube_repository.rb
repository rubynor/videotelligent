require 'open-uri'
require 'viddl-rb'

class YoutubeRepository
  def self.import_all
    import_categories
    import_videos
  end

  def self.download_link(video)
    yt = ViddlRb.get_urls_names("https://www.youtube.com/watch?v=#{video.uid}").first
    filename = yt[:name].gsub(/[^0-9A-Za-z.\-]/, '_')
    "#{yt[:url]}&title=#{filename}"
  end

  private
  def self.import_videos
    ContentProvider.all.map do |cp|
      account = Yt::Account.new(access_token: cp.token, refresh_token: cp.refresh_token)
      account.content_owners.map do |content_owner|
        content_owner.partnered_channels.map do |channel|

          begin
            channel.videos.map do |yt_video|
              video = to_video_from(Yt::Video.new(id: yt_video.id, auth: content_owner))
              video.save
              video
            end
          rescue Yt::Errors::RequestError => e
            if e.kind['code'] == 404
              []
            else
              raise e
            end
          end
        end
      end
    end.flatten
  end

  def self.import_categories
    yt_categories = Yt::Collections::VideoCategories.new.where(part: 'snippet', region_code: 'US')

    yt_categories.each do |yt_category|

      # TODO: Replace with a select when this PR is merged: https://github.com/Fullscreen/yt/pull/119
      if yt_category.snippet.data['assignable']
        category = Category.find_or_initialize_by(external_reference: yt_category.id)
        category.name = yt_category.title
        category.save
      end
    end
  end


  def self.to_video_from(yt_video)
    video = Video.find_or_initialize_by(uid: yt_video.id)

    video.uid = yt_video.id
    video.title = yt_video.title
    video.views = yt_video.view_count
    video.views_last_week = yt_video.views(since: 1.week.ago)[:total]
    video.likes = yt_video.like_count
    video.dislikes = yt_video.dislike_count
    video.thumbnail_url = yt_video.thumbnail_url(:medium)
    video.description = yt_video.description
    video.published_at = yt_video.published_at
    video.channel_title = yt_video.channel_title
    video.category = Category.find_by_external_reference(yt_video.category_id)
    video
  end
end
