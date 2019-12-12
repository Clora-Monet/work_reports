Rails.application.routes.draw do
  root 'lines#index'

  namespace :productions do
    resources :searches, only: :index
  end

  resources :lines do
    resources :productions
  end
end
