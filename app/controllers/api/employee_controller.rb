class Api::EmployeeController < ApplicationController
    before_action :authorize_employee, except: :create

    def index 
        @users = Employee.all
        render json: @users
    end

    def show
        authorize Current.user, policy_class: EmployeePolicy
        if Current.user.user_handle == params[:id]
            @employee = Employee.find_by(user_handle: params[:id])
            render :show
        else
            render json: {  "error": "Forbidden"  }, status: :forbidden 
        end
    end

    def add_expense
        authorize current_user, policy_class: EmployeePolicy
        data = json_payload
        expense = Expense.new(data)
        expense.employee_id = current_user[:id]
        expense.amount_claimed = 0
        expense.amount_approved = 0
        expense.status = "pending"
        begin
            expense.save
            render json: { "message": "expense created succesfully", "expense": expense }, status: 201
        rescue => e
            render json: {"error": "Please ensure you entered correct employee id"}, status: 502
        end
    end

    def get_expense
        authorize current_user, policy_class: EmployeePolicy
        @employee = Current.user
        @expenses = Expense.where(employee_id: @employee[:id])
        render :get_expense, status: 201
    end

    def comment_expense
        authorize current_user, policy_class: EmployeePolicy
        data = json_payload
        @employee = Current.user
        obj = {
            :user => data["user_handle"],
            :expense_id => data["expense_id"],
            :description => data["description"],
            :user_email => @employee.email
        }
        Api::CommentController.add_comment(obj)
    end
end
