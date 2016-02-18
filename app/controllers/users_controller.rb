class UsersController < ApplicationController
  before_action :authenticate_user!

  def me
    render json: current_user
  end

  def update
    content_owner = ContentOwner.find(params[:content_owner_id])
    current_user.update_attributes!(current_content_owner: content_owner)
    render json: {success: 'Cms updated'}
  end
end
