Rails.application.routes.draw do

  root   'static_pages#home'

  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'

  get    '/signup',  to: 'users#new'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get    '/creerreferent',           to: 'referents#new'
  get    '/creerorganisme',          to: 'organismes#new'
  get    '/creerorganismereferent',  to: 'organisme_referents#new'
  
  get    '/creerpointofservice',     to: 'point_of_services#new'
  get    '/creerunlocal',            to: 'un_locals#new'
  get    '/creerservice',            to: 'services#new'


  resources :organismes do
    member do
      get :ajouter, :retirer
      get :ajouter_retirer_org_ref, :ajouter_retirer_ref, :ajouter_retirer_point_service    
      get :organisme_id
    end
  end

  resources :organisme_referents do
    member do
      get :ajouter, :retirer
      get :ajouter_retirer_ref
    end
  end

  resources :referents do
    member do
      get :ajouter, :retirer
    end
  end

  resources :point_of_services do
    member do
      get :ajouter, :retirer
      get :ajouter_retirer_local
    end
  end

  resources :un_locals do
    member do
      get :ajouter, :retirer
      get :ajouter_retirer_service
    end
  end

  resources :services do
    member do
      get :ajouter, :retirer
    end
  end

  resources :account_activations,       only: [:edit]
  resources :password_resets,           only: [:new, :create, :edit, :update]
  resources :users

end
