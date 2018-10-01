Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  # Authentication, registration
  devise_for :users, skip: :registrations,
  controllers: {
    sessions: 'users/sessions'
  }

  devise_scope :user do
    resource :registration,
      only: [:new, :create, :edit, :update],
      path: 'users',
      path_names: { new: 'sign_up' },
      controller: 'users/registrations',
      as: :user_registration do
        get :cancel
      end
  end

  get '/users', to: redirect('/users/sign_in')


  # Admin Dashboard
  ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad


  root 'home#index'

  # Error handling
  match '404', to: 'error#not_found', via: :all
  match '500', to: 'error#server_error', via: :all
  match '418', to: 'error#teapot', via: :all

  # Schedules
  get 'schedule', to: 'schedules#current', as: 'current_schedule'
  get 'schedule/next', to: 'schedules#next', as: 'next_schedule'

  # Standalone player
  # POST required for Facebook Tab Page.
  # TODO: the above was written by prev. webmaster. Check whether it's true
  match 'listen', to: 'player#listen', as: "listen", via: [:get, :post]

  # Feed RSS
  get 'feed', to: 'feed#general', as: 'feed'

  # Posts
  resources :posts, only: ['show', 'index']

  # Teams
  resources :teams, only: ['show'] do
    get 'all_posts', on: :member, as: 'all_posts'
  end

  # Events
  resources :events, only: ['show']

  # Tags
  resources :tags, only: ['show']

  # Shows
  resources :shows, only: ['show', 'index'] do
    # /shows/all will also display shows not in schedule
    get 'all', on: :collection
    resources :podcasts, only: ['show']
  end

  # Techteam page
  get 'techteam', to: 'techteam#index', as: 'techteam'

  # FreshAir.org.uk IT instructions for users
  get 'help', to: 'static#help'

  # Report issue page
  get 'issue', to: 'issue#report', as: 'issue'
  post 'issue', to: 'issue#submit'
  get 'issue/submitted', to: 'issue#submitted', as: 'issue_submitted'


  scope 'api' do
    get 'broadcast_info', to: 'api#get_broadcast_info'
    post 'broadcast_info', to: 'api#set_broadcast_info'
    get 'users/:email/shows', to: 'api#shows_for_user', :constraints => { email: /[\w|.|-]+@[\w|.|-]+/ }
    get 'schedules/current', to: 'api#current_schedule'
    get 'shows/all', to: 'api#all_shows'
    get 'shows/:slug', to: 'api#show_by_slug'
    get 'shows/:slug/check-broadcast-time/:start(-:end)', to: 'api#check_broadcast_time', :constraints => { start: /[0-9]+/, end: /[0-9]+/ }
    get 'podcasts/:show_slug', to: 'api#podcasts_by_show'
  end

  # Static pages
  # (should be at the end of the file not to mess with other routes)
  resources :pages, path: '/', only: ['show'] do
    resources :sub_pages, path: '/', only: ['show']
  end

end
