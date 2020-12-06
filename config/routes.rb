Rails.application.routes.draw do
  
  # トップページ
  root 'static_pages#top'
  
  # ユーザー登録ページ
  get '/signup', to: 'users#new'
  
  # ログイン機能
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  
  # ユーザー
  resources :users
  
  # 漁場
  resources :grounds do
  
    member do
      get 'landing_show', to: 'landings#show'
      get 'landing_edit', to: 'landings#edit'
      patch 'landing_update', to: 'landings#update'
      delete 'landing_destroy', to: 'landings#destroy'
    end
    # 水揚げ
    resources :landings, only: [:new, :create]
  
  end
  
  # get 'landing_new', to: 'landings#new'
  get 'landing_index', to: 'landings#index'
  
  # 帳簿
  resources :accounts
  
end