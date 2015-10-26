IndustryMapping::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'admin/dashboard#index'

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1 do
      resources :terms, only: :index
    end
  end
end
