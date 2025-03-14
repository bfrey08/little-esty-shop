Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'


  get '/admin', to: 'admins#dashboard'

  get '/admin/merchants',                   to: 'admin_merchants#index'
  get '/admin/merchants/new',               to: 'admin_merchants#new'
  post '/admin/merchants',                  to: 'admin_merchants#create'
  patch '/admin/merchants/:merchant_id',    to: 'admin_merchants#update'
  get '/admin/merchants/:merchant_id/edit', to: 'admin_merchants#edit'
  get '/admin/merchants/:merchant_id',      to: 'admin_merchants#show'

  get '/admin/invoices',               to: 'admin_invoices#index'
  get '/admin/invoices/:invoice_id',   to: 'admin_invoices#show'
  patch '/admin/invoices/:invoice_id', to: 'admin_invoices#update'

  get '/admin/bulk_discounts', to: 'admin_bulk_discounts#index'

  # resources :admin, only: :index do
  #   resources :merchants, only: [:index, :new, :show, :create, :update, :edit]
  #   resources :invoices, only: [:index, :show]
  # end


  resources :merchants, only: [:show] do
    resources :discounts, controller: :merchant_discounts
    get '/merchants/:merchant_id/discounts/:id/edit', to: 'merchant_discounts#edit'
    resources :dashboard, only: [:index]
    resources :items, except: [:destroy], controller: :merchant_items
    resources :item_status, only: [:update]
    resources :invoices, only: [:index, :show, :update], controller: :merchant_invoices
  end
end
