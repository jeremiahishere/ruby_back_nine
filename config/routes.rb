RubyBackNine::Application.routes.draw do
  get "home/index"

  devise_for :users

  namespace :admin do
    resources :courses
    resources :holes
  end

  root :to => "home#index"
end
