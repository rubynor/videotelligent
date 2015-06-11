Rails.application.routes.draw do

  resources :videos, only: [:index, :show] do
    get :download, on: :member
  end

  resources :categories, only: [:index]

  get '/auth/:provider/callback', to: 'content_provider#import'

  root to: 'videos#index'

  get '/dashboard/home' => 'application#angular'
  get '/dashboard/*path' => 'application#angular'
end
