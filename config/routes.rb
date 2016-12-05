Rails.application.routes.draw do
  resources :orders do
    resource :report, only: [:new, :create, :destroy, :show]
  end

  root 'orders#index'
end
