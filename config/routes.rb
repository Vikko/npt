PollingTest::Application.routes.draw do
  
  resource :main do
    get :index
  end
  
  root :to => "main#index"

end
