# An example of how to namespace routes.

Rails.application.routes.draw do
  namespace :v1 do
    namespace :resources do
      get '/users/all' => 'users#all'
      post '/payments/card' => 'payments#card'
      namespace :users do
        get ':username' => :show
        get ':username/businesses/all' => :all_businesses
        get ':username/businesses/:business_name' => :business
        delete ':username' => :delete
      end
      
      get '/businesses/all' => 'businesses#all'
      namespace :businesses do
        get '/search/:query' => :search
        get ':name' => :show
        get ':name/products/all' => :all_products
        get ':name/products/:product_name' => :product
        get ':name/services/all' => :all_services
        get ':name/products/:service_name' => :service
        post ':name/contact' => :contact
        patch ':name' => :update
        put ':name' => :update
        delete ':name' => :delete
        post 'new'
      end
    end
  end
  
  post 'contact' => 'static_pages#contact'
  
  devise_for :users,
    path: 'auth',
    path_names: {
     sign_in: 'login',
     sign_out: 'logout',
     registration: 'register'
    },
    controllers: {
      sessions: 'sessions',
      registrations: 'registrations',
      confirmations: 'confirmations'
    }
  
  devise_scope :user do
    get '/confirmation-getting-started' => 'registrations#getting_started', as: 'confirmation_getting_started'
  end
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Delayed::Web::Engine, at: '/jobs'
  
  root :to => "apitome/docs#index"
end