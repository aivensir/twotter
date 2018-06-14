Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #resources :posts
  #resources :comments

  #get '/posts', to: 'home#return_posts'
  match '/posts', to: 'posts#return_posts', via: :get
  match '/posts', to: 'posts#create_new_post', via: :post
  match '/posts', to: 'posts#edit_post', via: :put
  match '/posts', to: 'posts#remove_post', via: :delete
  match '/posts/like', to: 'posts#like', via: :put
  match '/posts/dislike', to: 'posts#dislike', via: :delete


  match '/posts/:post_id', to: 'posts#return_post', via: :get

  match '/posts/:post_id/comments', to: 'comments#return_comments', via: :get
  match '/comments', to: 'comments#create_new_comment', via: :post
  match '/comments', to: 'comments#edit_comment', via: :put
  match '/comments', to: 'comments#remove_comment', via: :delete
  match '/comments/like', to: 'comments#like', via: :put
  match '/comments/dislike', to: 'comments#dislike', via: :delete


  match '/users/session', to: 'users#token_auth', via: :post
  match '/users/login', to: 'users#login', via: :post
  match '/users/sign_up', to:'users#create', via: :post
  match '/users/logout', to:'users#logout', via: :post
  match '/users/change_password', to:'users#change_password', via: :put

end
