Riecnews::Application.routes.draw do
  resources :logs, :only => :index
  resources :comments do
    collection do
      post 'validate'
      get 'verify'
    end
    member do
      get 'sent'
    end
  end

  match 'user/edit' => 'users#edit', :as => :edit_current_user
  match 'signup' => 'users#new', :as => :signup
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login
  match 'toggle_language' => 'application#toggle_language', :as => :toggle_language
  match 'index-j.shtml', :controller => "comments", :action => "new"

  resources :sessions
  resources :users do
    member do
      get 'edit_roles'
      put 'update_roles'
    end
  end

  match 'welcome' => 'comments#new'
  root :to => "comments#new"
end
