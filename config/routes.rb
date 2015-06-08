Rails.application.routes.draw do

  resources :videos, except: [:destroy, :edit] do
    get :download, on: :member
  end

  get '/auth/:provider/callback', to: 'content_provider#import'

  root to: 'videos#index'

  get '/dashboard/home' => 'application#angular'
  get '/dashboard/*path' => 'application#angular'
end
