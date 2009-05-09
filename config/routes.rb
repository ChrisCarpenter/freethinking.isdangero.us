ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.resources :posts
    admin.resources :discussions
  end
  
  map.resources :posts
  map.resources :discussions

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.connect '/', :controller => 'front'
end
