Rails.application.routes.draw do
  
  get 'index/home'
  get 'index/go'
  get 'index/not_found'
  post 'index/home'
  
  get 'stats/stats'

  root 'index#home'
  
  match ':short', to: 'index#go', via: [:get]
  match '/stats/:short', to: 'stats#stats', via: [:get]

end
