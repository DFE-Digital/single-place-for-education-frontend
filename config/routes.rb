Rails.application.routes.draw do
  root 'home#index'
  get 'case-study/:slug', to: 'case_study#show'
end
