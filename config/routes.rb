PollingTest::Application.routes.draw do
  
  resources :sensors do
    collection do
      get :index
      get :start
      get :stop
    end
  end
  
  root :to => "sensors#index"

end
