Rails.application.routes.draw do
  root 'lines#index'

  resources :lines do
    resources :productions
  end
end
