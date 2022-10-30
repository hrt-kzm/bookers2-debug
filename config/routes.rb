Rails.application.routes.draw do
  get 'relationships/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:index, :show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'following_user' => 'relationships#following_user', as: 'following_user'
    get 'followed_user' => 'relationships#followed_user', as: 'followed_user'
  end
  get '/search' => 'searches#search'
  root to: 'homes#top'
  get 'home/about' => 'homes#about', as: 'about'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
