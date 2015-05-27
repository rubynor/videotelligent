Rails.application.routes.draw do

  resources :videos, only: [:index, :new, :create]

  get '/auth/:provider/callback', to: 'content_provider#import'

  root to: 'videos#index'

  #root 'application#angular'

  get '/*path' => 'application#angular'
end
