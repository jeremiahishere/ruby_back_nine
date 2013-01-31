RubyBackNine::Application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :courses
    resources :holes
    root :to => "pages#index"
  end

  root :to => "pages#index"
end
