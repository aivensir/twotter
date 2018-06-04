Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'home#index'
  match '/posts', to: 'home#return_posts', via: :get
  match '/posts', to: 'home#create_new_post', via: :post
  match '/posts', to: 'home#edit_post', via: :put
  match '/posts', to: 'home#remove_post', via: :delete

  match '/posts/:post_id', to: 'home#return_post', via: :get

  match '/posts/:post_id/comments', to: 'home#return_comments', via: :get
  match '/comments', to: 'home#create_new_comment', via: :post
  match '/comments', to: 'home#edit_comment', via: :put
  match '/comments', to: 'home#remove_comment', via: :delete

end
