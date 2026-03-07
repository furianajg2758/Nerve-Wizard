# config/routes.rb
Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Point the root directly to the restart method
  root "wizard#restart"

  resources :wizard, only: [:show, :update] do
    collection do
      get :restart
    end
  end
end