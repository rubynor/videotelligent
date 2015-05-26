Rails.application.routes.draw do

  resources :videos, only: [:index, :new, :create]
  root to: 'videos#index'

  #root 'application#angular'

  get '/*path' => 'application#angular'
end
