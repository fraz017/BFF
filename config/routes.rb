Rails.application.routes.draw do
  get 'users/index'

  get 'messages/index'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, path: '', path_names: { sign_in: 'login', sign_up: 'register'}
 
  root to: "messages#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
