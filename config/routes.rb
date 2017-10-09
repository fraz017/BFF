Rails.application.routes.draw do
	mount ActionCable.server => '/cable'

	namespace "admin" do
    get "/dashboard" => "dashboards#dashboard"
    get "/logs" => "dashboards#logs"
    get "/reported_messages" => "dashboards#reported_messages"
    get "/send_message" => "dashboards#send_message"
    get "/delete_message/:id" => "dashboards#delete_message"
		get "/broadcast_message" => "dashboards#broadcast_message"
    get '/profile/:id' => "dashboards#profile"
    post '/block_unblock' => 'dashboards#block_unblock'
    resources :available_categories
	end
  get '/profile' => 'users#profile'
  patch "/users/:id" => 'users#update', as: :update
  get 'messages/index'
  post '/messages' => "messages#post_message"
  post '/messages/report' => "messages#report"
 	post '/messages/like' => "messages#like"
 	post '/reply' => "messages#post_reply"
  post '/save_category' => 'messages#save_category'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, path: '', path_names: { sign_in: 'login', sign_up: 'register'}
 
  root to: "messages#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
