class ContentProviderController < ApplicationController
  def import
    content_provider = ContentProvider.from_omniauth(request.env['omniauth.auth'])
    session[:user_id] = content_provider.id
    flash[:success] = "#{content_provider.name} successfully imported"
    redirect_to root_url
  end

end