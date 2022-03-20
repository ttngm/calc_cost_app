Rails.application.routes.draw do
  root 'usage_details#index'
  post   '/usage_details/getRakuten',   to: 'usage_details#getRakuten'
  get '/usage_details', to:'usage_details#index'
  resources :usage_details
  resources :usage_amounts

end
