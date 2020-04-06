# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, :defaults => { :format => 'json' } do
    scope '(:apiv)', :module => :v2,
                     :defaults => { :apiv => 'v2' },
                     :apiv => /v1|v2/,
                     :constraints => ApiConstraints.new(:version => 2, :default => true) do
      constraints(:id => /[^\/]+/) do
        resources :omaha_reports, :only => [:index, :show, :destroy] do
          get :last, :on => :collection
        end
        resources :omaha_groups, :only => [:index, :show]
      end
      resources :omaha_reports, :only => [:create]
    end
  end

  resources :omaha_reports, :only => [:index, :show, :destroy] do
    collection do
      get 'auto_complete_search'
    end
  end

  resources :omaha_groups, :only => [:index, :show] do
    collection do
      get 'auto_complete_search'
    end
  end

  resources :omaha_hosts, only: :index do
    collection do
      get 'auto_complete_search'
    end
  end

  constraints(:id => /[^\/]+/) do
    resources :hosts do
      constraints(:host_id => /[^\/]+/) do
        resources :omaha_reports, :only => [:index, :show]
      end
    end
  end
end
