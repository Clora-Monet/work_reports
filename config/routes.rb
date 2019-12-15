Rails.application.routes.draw do
  root 'lines#index'
  namespace :productions do
    resources :searches, only: :index do
      collection do
        get 'search'
      end
    end
  end

  resources :lines do
    resources :productions
  end
end
