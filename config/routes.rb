Rails.application.routes.draw do
  namespace :operator do
    resources :histories, only: [:index]
    resources :home, only: [:index] do 
      collection do 
        get "amount", to: "home#amount"
        get "reload", to: "home#reload"
        get "reload_campaign/:id", to: "home#reload_campaign", as: :reload_campaign
        get "export", to: "home#export"
        get "export_campaign/:id", to: "home#export_campaign", as: :export_campaign
        post "import", to: "home#import"
        get "campaign/:id", to: "home#campaign", as: :campaign
      end
    end
    resources :fixed_campaign, only: [:index] do
      collection do
        get "campaign/:id", to: "fixed_campaign#campaign", as: :campaign
        get "export_campaign/:id", to: "fixed_campaign#export_campaign", as: :export_campaign
        get 'export_overload_campaign', to: "fixed_campaign#export_overload_campaign", as: :export_overload_campaign
      end
    end 
    resources :setting, only: [:index, :edit, :update] do 
      collection do
        get "edit_campaign/:id", to: "setting#edit_campaign", as: :edit_campaign
        get "edit_fixed_campaign/:id", to: "setting#edit_fixed_campaign", as: :edit_fixed_campaign
        get "new_campaign"
        get "new_fixed_campaign"
        post "create_campaign", to: "setting#create_campaign", as: :create_campaign
        post "create_fixed_campaign", to: "setting#create_fixed_campaign", as: :create_fixed_campaign
        patch "update_campaign/:id", to: "setting#update_campaign", as: :update_campaign
        patch "update_fixed_campaign/:id", to: "setting#update_fixed_campaign", as: :update_fixed_campaign
        delete "destroy_campaign/:id", to: "setting#destroy_campaign", as: :destroy_campaign
        delete "destroy_fixed_campaign/:id", to: "setting#destroy_fixed_campaign", as: :destroy_fixed_campaign
      end
    end
    root "home#index"
  end
  namespace :api do 
    resources :sync_kyc, only: [:create]
  end
end
