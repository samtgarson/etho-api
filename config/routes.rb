Rails.application.routes.draw do
  constraints subdomain: 'api' do
    get '/' => 'application#greeting', as: :api_root

    resources :users, only: [:show]

    post 'auth' => 'auth#create'
    get 'heartbeat' => 'application#heartbeat'

    get '/users/:id/stats' => 'users#stats', as: :stats
    %i(time colours tags).each do |method|
      get "/users/:id/stats/#{method}" => "users##{method}", as: method
    end

    get '/404' => 'application#not_found', as: :not_found
    get '/500' => 'application#application_error', as: :application_error
  end

  root 'application#index', as: :client_root
  get '*path' => 'application#index'
end
