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
      delete 'landing_destroy', to: 'landings#destroy'
    end
    # 水揚げ
    resources :landings, only: [:new, :create, :edit, :update]
  
  end
  
  get 'landing_index', to: 'landings#index'
  get 'landing_pre_new', to: 'landings#pre_new'
  
  # 帳簿（売上帳）
  resources :accounts do
    
    member do
      # 帳簿（振替伝票）
      get 'transfer_slip_edit'
      patch 'transfer_slip_update'
      delete 'transfer_slip_destroy'
      
      # 帳簿（仕入帳）
      get 'purchasing_show'
      get 'purchasing_edit'
      patch 'purchasing_update'
      delete 'purchasing_destroy'
      
      # 帳簿（現金出納帳）
      get 'cash_show'
      get 'cash_edit'
      patch 'cash_update'
      delete 'cash_destroy'
      
      # 帳簿（当座預金出納帳）
      get 'current_show'
      get 'current_edit'
      patch 'current_update'
      delete 'current_destroy'
    end
    
    collection do
      # 帳簿（振替伝票）
      get 'transfer_slip_new'
      post 'transfer_slip_create'
      
      # 帳簿（仕入帳）
      get 'purchasing_new'
      post 'purchasing_create'
      get 'purchasing_index'
      
      # 帳簿（現金出納帳）
      get 'cash_new'
      post 'cash_create'
      get 'cash_index'
      
      # 帳簿（当座預金出納帳）
      get 'current_new'
      post 'current_create'
      get 'current_index'
      
      # 仕訳帳
      get 'journal_books'
      # 総勘定元帳
      get 'general_ledger'
      get 'purchasing_general_ledger'
      get 'cash_general_ledger'
      get 'current_general_ledger'
      get 'payable_general_ledger'
      get 'receivable_general_ledger'
      # 貸借対照表
      get 'balance_sheet'
      # 損益計算書
      get 'profit_and_loss_statement'
      
    end
    
     # 複合仕訳（削除）
    resources :compound_journals, only: :destroy do
    end
  end
  
  
  
  
  
end