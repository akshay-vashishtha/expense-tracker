Rails.application.routes.draw do
  namespace :api do 
    resources :employee, except: %i[create index]
    resources :admin
    resources :expense, except: %i[create index]
    resources :bill, except: %i[index]
    resources :comment
    post "create_employee", to: "admin#add_employee"
    post "create_expense", to: "employee#add_expense"
    get "employee/get_expenses/:id", to: "employee#get_expense"
    get "admin/search_expense/:id", to: "admin#search_expense"
    get "invoice_validator", to: "bill#invoice_validator"
    get "list_pending_expense", to: "admin#list_pending_expense"
    get "approve_bill/:id", to: "admin#approve_bill"
    get "reject_bill/:id", to: "admin#reject_bill"
    post "add_comment/:id", to: "comment#add_comment"
    post '/auth/login_admin', to: 'authentication#login_admin'
    post '/auth/login_employee', to: 'authentication#login_employee'
    post 'admin/terminate_employee', to: 'admin#terminate_employee'
    get 'list_employee', to: 'admin#list_employee'
    get 'list_expense', to: 'admin#list_expense'
    get 'list_bills', to: 'admin#list_bills'
  end
end
