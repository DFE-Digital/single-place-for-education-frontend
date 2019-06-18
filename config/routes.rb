Rails.application.routes.draw do
  root 'home#index'
  get 'case-study/:slug', to: 'case_study#show'
  get 'sub-category/:slug', to: 'sub_category#index'
  get 'tvs', to: 'tvs#index'
end
