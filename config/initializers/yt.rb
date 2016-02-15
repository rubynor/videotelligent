Yt.configure do |config|
  config.api_key = ENV['GOOGLE_API_KEY']
  config.log_level = :devel # This outputs curl strings to stdout for the requests
  # Necessary for now (also set in omniauth.rb) because of https://github.com/Fullscreen/yt/issues/189
  config.client_id = ENV['GOOGLE_CLIENT_ID']
  config.client_secret = ENV['GOOGLE_CLIENT_SECRET']
end

# Add unsupported attribute :display_name for content_owners
# TODO: Make pullrequest with these changes
class Yt::Collections::ContentOwners
  private
  def attributes_for_new_item(data)
    {
      owner_name:     data['id'],
      display_name:   data['displayName'],
      authentication: @auth.authentication
    }
  end
end

class Yt::Models::ContentOwner
  attr_reader :display_name

  def initialize(options = {})
    super options
    @owner_name = options[:owner_name]
    @display_name = options[:display_name]
  end
end
###
