Rails.application.routes.draw do
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake/rails routes"

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  get "/auth/:provider/callback" => "sessions#create_from_omniauth"


  # Example of regular route:
  # get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  # get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller action automatically):
  # resources :products

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
