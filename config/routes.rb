Rails.application.routes.draw do
  get 'players/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#home'
  resources :teams
  resources :fixtures do
  	collection do
  		get 'to_complete' => 'fixtures#tocomplete'
  	end
  end	
  resources :ranks, only: [:index]
  get 'init_ranks', to: 'ranks#initializeranking'
  resources :players, only:[:index]
end
