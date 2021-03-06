PollingTest::Application.routes.draw do
  
  resources :sensors do
    collection do
      get :index
      get :start
      get :stop
      get :get_data
      post :post_data
      get :test_json
      post :delete_all
    end
  end
  
  root :to => "sensors#index"

end
