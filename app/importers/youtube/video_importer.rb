module Youtube
  class VideoImporter

    def initialize
      @excluded_channel_ids = ENV['EXCLUDED_CHANNEL_IDS'].split(',') if ENV['EXCLUDED_CHANNEL_IDS']
      @excluded_channel_ids ||= []
      @interesting_countries = %w(DK EE FI FO GB IE IS LT LV NO SE AT BE CH DE
                            FR LI LU HU MD PL RO RU SK UA AL BA ES GR
                            HR IT ME MK MT RS PT SI) # Most countries in Europe
    end

    def import_all
      start_time = Time.now
      ContentProvider.all.each do |cp|
        import_for(cp)
      end
    ensure
      end_time = Time.now
      puts "Import ended at #{end_time} and took #{end_time - start_time} seconds"
    end

    def import_for(content_provider)
      account = Yt::Account.new(refresh_token: content_provider.refresh_token)
      account.content_owners.each do |content_owner|
        content_owner.partnered_channels.each do |channel|

          next if @excluded_channel_ids.include?(channel.id)

          begin
            channel.videos.each do |yt_video|
              SingleVideoImporter.new(
                YtVideoAdapter.new(Yt::Video.new(id: yt_video.id, auth: content_owner)),
                content_owner,
                @interesting_countries
              ).import_video
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
