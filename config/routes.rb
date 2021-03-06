RubyBackNine::Application.routes.draw do
  get "home/index"

  devise_for :users

  namespace :admin do
    resources :courses
    resources :holes
    root :to => "pages#index"
  end
  
  namespace :API do
    resources :courses, :holes, :solutions, :test_cases
    root :to => "home#index"
  end

  root :to => "home#index"
end
