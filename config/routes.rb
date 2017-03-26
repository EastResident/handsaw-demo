Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api, format: 'json' do
    resources :handsaws, only: :index do
      collection { post :convert }
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
