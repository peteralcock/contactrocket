
require 'sidekiq/web'
require 'sidekiq-status/web'

Rails.application.routes.draw do

  get '/health_check' => 'health_check#index'
  get '/faq'  => 'visitors#faq'
  get '/terms'  => 'visitors#terms'
  get '/unsubscribe'  => 'visitors#unsubscribe'

  devise_for :users, :controllers => { :confirmations => 'confirmations', :registrations => 'registrations', :passwords => 'passwords', sessions: 'sessions', omniauth_callbacks: 'users/omniauth_callbacks'}

  devise_scope :user do
    put "/confirm" => "confirmations#confirm"
  end

  mount Koudoku::Engine, at: 'koudoku'
  scope module: 'koudoku' do
    get 'pricing' => 'subscriptions#index', as: 'pricing' # , constraints: { protocol: 'https' }
  end

  as :user do
    get 'user/password/new', :to => 'devise/passwords#new'
    patch '/user/confirmation' => 'confirmations#update', :via => :patch, :as => :update_user_confirmation
    get 'users/profile', :to => 'devise/registrations#edit', :as => :user_root
    get '/login' => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'
    get '/register'  =>  'devise/registrations#new'
    get '/crm'  =>  'dashboard#crm'
    get '/crm/leads'  =>  'dashboard#leads'
    get '/crm/accounts'  =>  'dashboard#accounts'
    get '/crm/contacts'  =>  'dashboard#contacts'
    get '/crm/tasks'  =>  'dashboard#tasks'
    get '/marketing/campaigns'  =>  'dashboard#marketing_campaigns'
    get '/marketing/reports'  =>  'dashboard#marketing_reports'
    get '/marketing/templates'  =>  'dashboard#marketing_templates'
    get '/crm/opportunities'  =>  'dashboard#opportunities'
    get '/crm/profile'  =>  'dashboard#profile'
    get '/help'  =>  'dashboard#helpdesk'

    get '/crm/campaigns'  =>  'dashboard#campaigns'
    resources :websites
    resources :websites do
      collection { post :import }
    end

    resources :email_leads
    resources :social_leads
    resources :phone_leads
    resources :companies
    resources :people

    post '/dashboard' => 'dashboard#import', :as => :import_websites_path

    get '/email_leads/remove/:id'  => 'email_leads#delete', :as => :remove_email_lead_path
    get '/phone_leads/remove/:id'  => 'phone_leads#delete', :as => :remove_phone_lead_path
    get '/social_leads/remove/:id'  => 'social_leads#delete', :as => :remove_social_lead_path

    get '/email_leads/add/:id'  => 'email_leads#add', :as => :add_email_lead_path
    get '/phone_leads/add/:id'  => 'phone_leads#add', :as => :add_phone_lead_path
    get '/social_leads/add/:id'  => 'social_leads#add', :as => :add_social_lead_path

    get '/dashboard'  => 'dashboard#index', :as => :signed_in_root_path
    get '/search'  => 'dashboard#index', :as => :search_path
    post '/targets' => 'dashboard#create_target', :as => :targets_path
    get '/analytics'  => 'dashboard#analytics', :as => :analyics_path

    get '/stats' => 'events#stats'
    get '/batch' => 'events#batch'
    get '/progress' => 'events#progress'

  end

  if Rails.env.production?
  constraints subdomain: 'api' do

    post '/text/sentiment' =>  'text#sentiment'
    post '/text/nlp' =>  'text#nlp'
    post '/text/chat' =>  'text#chat'
    post '/text/analyze' =>  'text#analyze'
    post '/text/summarize' =>  'text#summarize'
    get '/website/locate' =>  'geoip#locate'
    post '/face/find' =>  'face#find'
    post '/face/rank' =>  'face#rank'
    post '/face/add' =>  'face#add'
    post '/face/identify' =>  'face#identify'
    post '/image/add' =>  'image#add'
    post '/image/delete' =>  'image#delete'
    post '/image/list' =>  'image#list'
    post '/image/ping' =>  'image#ping'
    post '/image/detect' =>  'image#detect'
    post '/image/ocr' =>  'image#ocr'

    scope module: 'api' do
      namespace :v1 do
        resources :people
        resources :companies
        resources :websites
        resources :email_leads
        resources :social_leads
        resources :phone_leads
        resources :workers
        post '/ner' =>  'workers#extract_entities'
        post '/text' =>  'workers#analyze_text'
        post '/validate' =>  'workers#validate_email'
        post '/email' =>  'workers#analyze_email'
        post '/phone' =>  'workers#analyze_phone'
        post '/name' =>  'workers#analyze_name'
        post '/product' =>  'workers#extract_product'
        post '/domain' =>  'workers#analyze_domain'
        post '/profile' =>  'workers#social_shares'
        post '/add' =>  'workers#add_image'
        post '/ocr' =>  'workers#ocr_image'
        post '/compare' =>  'workers#compare_image'
        post '/search' =>  'workers#search_image'
        post '/delete' =>  'workers#delete_image'
        post '/predict' =>  'workers#predict_image'
        post '/train' =>  'workers#train_image'
        post '/gender' =>  'workers#predict_gender'
        post '/age' =>  'workers#predict_age'
      end
    end


  end

  else
    post '/text/sentiment' =>  'text#sentiment'
    post '/text/nlp' =>  'text#nlp'
    post '/text/chat' =>  'text#chat'
    post '/text/analyze' =>  'text#analyze'
    post '/text/summarize' =>  'text#summarize'
    get '/website/locate' =>  'geoip#locate'
    post '/face/find' =>  'face#find'
    post '/face/rank' =>  'face#rank'
    post '/face/add' =>  'face#add'
    post '/face/identify' =>  'face#identify'
    post '/image/add' =>  'image#add'
    post '/image/delete' =>  'image#delete'
    post '/image/list' =>  'image#list'
    post '/image/ping' =>  'image#ping'
    post '/image/detect' =>  'image#detect'
    post '/image/ocr' =>  'image#ocr'

    scope module: 'api' do
      namespace :v1 do
        resources :people
        resources :companies
        resources :websites
        resources :email_leads
        resources :social_leads
        resources :phone_leads
        resources :workers
        post '/ner' =>  'workers#extract_entities'
        post '/text' =>  'workers#analyze_text'
        post '/validate' =>  'workers#validate_email'
        post '/email' =>  'workers#analyze_email'
        post '/phone' =>  'workers#analyze_phone'
        post '/name' =>  'workers#analyze_name'
        post '/product' =>  'workers#extract_product'
        post '/domain' =>  'workers#analyze_domain'
        post '/profile' =>  'workers#social_shares'
        post '/add' =>  'workers#add_image'
        post '/ocr' =>  'workers#ocr_image'
        post '/compare' =>  'workers#compare_image'
        post '/search' =>  'workers#search_image'
        post '/delete' =>  'workers#delete_image'
        post '/predict' =>  'workers#predict_image'
        post '/train' =>  'workers#train_image'
        post '/gender' =>  'workers#predict_gender'
        post '/age' =>  'workers#predict_age'
      end
    end
  end



  authenticate :user, -> (user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'visitors#index'

 end

