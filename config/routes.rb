StampsDemo::Application.routes.draw do
  resources :shipping_labels
  resources :shipping_rates
  resources :addresses

  # Root is set to the New action to bypass a extra click durring development.
  root :to => 'shipping_labels#new'

end
