class ContentProviderController < ApplicationController
  def import


    flash[:success] = "#{content_provider.name} successfully imported"
    redirect_to root_url
  end

end