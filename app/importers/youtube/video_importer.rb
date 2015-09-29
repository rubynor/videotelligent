module Youtube
  class VideoImporter

    def initialize
      @excluded_channel_ids = ENV['EXCLUDED_CHANNEL_IDS'].split(',') if ENV['EXCLUDED_CHANNEL_IDS']
      @excluded_channel_ids ||= []
    end

    def import_all
      ContentProvider.all.each do |cp|
        import_for(cp)
      end
    end

    def import_for(content_provider)
      account = Yt::Account.new(refresh_token: content_provider.refresh_token)
      account.content_owners.each do |content_owner|
        content_owner.partnered_channels.each do |channel|

          next if @excluded_channel_ids.include?(channel.id)

          begin
            channel.videos.each do |yt_video|
              SingleVideoImporter.new(Yt::Video.new(id: yt_video.id, auth: content_owner)).import_video
            end
          rescue Yt::Errors::RequestError => e
            unless e.kind['code'] == 404
              raise e
            end
          end
        end
      end
    end

  end
end