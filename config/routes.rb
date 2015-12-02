Rails.application.routes.draw do
  resources :users, only: [:show]

  get 'auth/:code' => 'auth#create'
  get 'heartbeat' => 'application#heartbeat'

  get '/users/:id/stats' => 'users#stats', as: :stats
  %i(time colours tags).each do |method|
    get "/users/:id/stats/#{method}" => "users##{method}", as: method
  end
end
