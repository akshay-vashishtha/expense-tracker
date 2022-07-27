Rails.application.routes.draw do
  namespace :api do 
    resources :employee
    resources :admin
    resources :expense
    resources :bill
    resources :comment
    # namespace :employee do
      get "employee/get_expenses/:id", to: "employee#get_expense"
      get "admin/search_expense/:id", to: "admin#search_expense"
      get "invoice_validator", to: "bill#invoice_validator"
      get "list_pending_expense", to: "admin#list_pending_expense"
      get "approve_bill/:id", to: "admin#approve_bill"
      get "reject_bill/:id", to: "admin#reject_bill"
      post "admin/comment", to: "admin#comment_expense"
      post "employee/comment", to: "employee#comment_expense"
      post '/auth/login_admin', to: 'authentication#login_admin'
      post '/auth/login_employee', to: 'authentication#login_employee'
    # end
  end
end
