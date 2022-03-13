Rails.application.routes.draw do
  root 'usage_details#index'
  resources :usage_details
end
