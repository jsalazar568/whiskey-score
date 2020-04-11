Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :whiskeys, only: [:index, :show, :create]
      resources :whiskey_brands, only: [:index]
      resources :users, only: [:create]
      resources :reviews, only: [:index, :create]
    end
  end
  root 'homepage#index'
  get '/*path' => 'homepage#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
