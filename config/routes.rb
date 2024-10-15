Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :expenses, only: :create
  root to: "base#dashboard"
  get 'people/:id', to: 'base#show_person', as: :show_person
end
