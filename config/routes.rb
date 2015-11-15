Rails.application.routes.draw do
  
  root 'static_pages#home'
  put '/load_data', to: 'static_pages#load_data', as: 'load_data'
  put '/calculate_season', to: 'static_pages#calculate_season', as: 'calculate_season'
  put '/calculate_match', to: 'static_pages#calculate_match', as: 'calculate_match'
  put '/predict_match', to: 'static_pages#predict_match', as: 'predict_match'
  put '/reset', to: 'static_pages#reset', as: 'reset'
end
