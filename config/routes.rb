Rails.application.routes.draw do
  
  get 'index/expand'
  get 'index/home'
  get 'index/not_found'
  post 'index/home'
  
  get 'stats/stats'

  root 'index#home'
  
  match ':short', to: 'index#expand', via: [:get]
  match '/stats/:short', to: 'stats#stats', via: [:get]

end
