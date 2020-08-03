Rails.application.routes.draw do
  root 'admin#index'

  resources :orders, only: [:index, :show], param: :number do
    get :cancel, on: :member
  end

  resources :reports, only: :index do
  end
end
