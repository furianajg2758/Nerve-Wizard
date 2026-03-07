Rails.application.routes.draw do
  root "wizard#restart"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :wizard, only: [:show, :update] do
    collection do
      get :start
      get :restart
    end
  end

  get "/restart", to: "wizard#restart"
end