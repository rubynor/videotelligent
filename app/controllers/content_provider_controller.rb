class ContentProviderController < ApplicationController
  def import
    content_provider = ContentProvider.from_omniauth(request.env['omniauth.auth'])
    Youtube::VideoImporter.new.delay.import_for(content_provider)
    flash[:success] = "#{content_provider.name} successfully authorized and queued for importing"

    redirect_to root_url
  end

end