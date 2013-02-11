RubyBackNine::Application.routes.draw do
  get "home/index"

  devise_for :users

  namespace :admin do
    resources :courses
    resources :holes
    root :to => "pages#index"
  end
  
  namespace :API do
    resources :courses, :holes
    root :to => "home#index"
  end
  
  resources :courses, :holes

  root :to => "home#index"
end
