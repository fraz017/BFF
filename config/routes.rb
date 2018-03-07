Rails.application.routes.draw do
  resources :rooms, param: :name
  resources :single_messages

  mount ActionCable.server => '/cable'

  namespace "admin" do
    get "/dashboard" => "dashboards#dashboard"
    get "/logs" => "dashboards#logs"
    get '/import_file' => 'dashboards#import_file'
    post '/import' => 'dashboards#import'
    get "/reported_messages" => "dashboards#reported_messages"
    get "/send_message" => "dashboards#send_message"
    get "/delete_message/:id" => "dashboards#delete_message"
    get "/broadcast_message" => "dashboards#broadcast_message"
    get '/profile/:id' => "dashboards#profile"
    get '/change_role/:id' => "dashboards#change_role"
    post '/block_unblock' => 'dashboards#block_unblock'
    post '/change_category' => 'dashboards#change_category'
    get '/messages' => 'dashboards#messages'
    get '/refresh_messages' => 'dashboards#refresh_messages'
    resources :available_categories
  end

  post '/admin/create' => 'rooms#admin_create'
  get '/profile' => 'users#profile'
  patch "/users/:id" => 'users#update', as: :update
  post '/users/feedback' => 'users#feedback'
  get 'messages/index'
  get '/accept/:id' => 'single_messages#accept'
  get '/reject/:id' => 'single_messages#reject'
  get '/refresh_header' => 'users#refresh_header'
  post '/messages' => "messages#post_message"
  post '/messages/report' => "messages#report"
  post '/messages/like' => "messages#like"
  post '/reply' => "messages#post_reply"
  post '/save_category' => 'messages#save_category'
  get '/personal_chats/:id' => 'single_messages#personal_chats'

  devise_for :users, :controllers => {:registrations => "users/registrations", :omniauth_callbacks => "users/omniauth_callbacks", confirmations: 'confirmations'}, path: '', path_names: {sign_in: 'login', sign_up: 'register'}

  root to: "messages#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
