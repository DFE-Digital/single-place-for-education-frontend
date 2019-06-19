Rails.application.routes.draw do
  root 'home#index'
  get 'case-study/:slug', to: 'case_study#show'
  get 'category/:slug', to: 'category#index'
  get 'sub-category/:slug', to: 'sub_category#index'
  get 'tvs', to: 'tvs#index'
  get 'in-development', to: 'home#placeholder'
end
