class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])
    content_provider = ContentProvider.from_omniauth(request.env['omniauth.auth'])

    begin
      account = Yt::Account.new(refresh_token: content_provider.refresh_token)
      account.content_owners.each do |yt_content_owner|
        content_owner = ContentOwner.find_or_initialize_by(uid: yt_content_owner.owner_name)
        content_owner.name = yt_content_owner.display_name
        content_owner.content_provider = content_provider
        content_owner.save!
      end
    rescue Yt::Errors::Forbidden => e
      puts "Error: Could not request content_owners"
      puts e
    end

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Google"
      sign_in @user, :event => :authentication
      render json: { success: 'Signed in' }
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      render json: {
        error: I18n.t("devise.omniauth_callbacks.failure",
                      kind: "Google",
                      reason: "User could not be saved")
      }, status: 500
    end
  end

  def failure
    render json: { error: request.env['omniauth.error'].to_s }, status: 500
  end
end
