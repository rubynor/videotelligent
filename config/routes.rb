Rails.application.routes.draw do
  root 'application#angular'

  get '/*path' => 'application#angular'
end
