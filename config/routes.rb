Rails.application.routes.draw do

  resources :videos, only: [:index, :new, :create] do
    get :download
  end

  get '/auth/:provider/callback', to: 'content_provider#import'

  root to: 'videos#index'

  get '/dashboard/home' => 'application#angular'
  get '/dashboard/*path' => 'application#angular'
end
