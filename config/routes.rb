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

  get 'guidance/:slug', to: 'guidance#show'

  get 'resource/how-to-run-a-retro', to: 'resource#retro'
  get 'resource/using-meditation-to-create-a-culture-of-respect-and-trust', to: 'resource#respect_and_trust'
  get 'resource/answer-questions-using-scaffold', to: 'resource#structured_questions'
  get 'resource/making-effective-use-of-teaching-assistants', to: 'resource#teaching_assistants'
  get 'resource/get-children-to-think-for-themselves', to: 'resource#manage_behaviour'
  get 'resource/ecf-roll-out', to: 'resource#ecf_rollout'
  get 'resource/using-ground-rules-to-create-a-culture-of-respect-and-trust', to: 'resource#ground_rules'
end
