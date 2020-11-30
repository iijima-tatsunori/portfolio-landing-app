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
  
  # 水揚げ
  resources :landings
  
  # 帳簿
  resources :accounts
  
end