Rails.application.routes.draw do
	mount ActionCable.server => '/cable'
  get '/profile' => 'users#profile'
  patch "/users/:id" => 'users#update', as: :update
  get 'messages/index'
 	post '/messages' => "messages#post_message"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, path: '', path_names: { sign_in: 'login', sign_up: 'register'}
 
  root to: "messages#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
