Rails.application.routes.draw do
  root 'home#index'
  get 'case-study/:slug', to: 'case_study#show'

  get 'category/hiring', to: 'category#hiring'
  get 'category/get-a-job', to: 'category#get_a_job'
  get 'category/staff-voices', to: 'category#staff_voices'

  get 'category/:slug', to: 'category#index'
  get 'sub-category/:slug', to: 'sub_category#index'
  get 'tvs', to: 'tvs#index'
  get 'in-development', to: 'home#placeholder'
  get 'resource/how-to-run-a-retro', to: 'resource#retro'
  get 'guidance/:slug', to: 'guidance#show'
end
