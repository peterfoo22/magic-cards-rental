Rails.application.routes.draw do
  root to: 'pages#home'
  get "profiles/:id", to: "pages#user_profile", as: :user_profile

  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  resources :cards, only: [:new, :create, :index, :show, :destroy, :edit, :update] do
    resources :bookings, only: [:new, :create, :index, :show]
    resources :reviews, only:[:index, :create, :new]
  end

  post 'bookings', to: 'bookings#createmany'
end
