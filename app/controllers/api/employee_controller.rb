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

    def create
        data = json_payload
        employee = Employee.new(data)
        if Employee.exists?(:user_handle => "#{employee[:user_handle]}")
            render json: {"error": "Already exits"}
        else
            Api::AdminController.add_employee(employee)
            if employee.save
                render json: {"message": "employee created succesfully" }, status: 201
            else
                render json: {"error": "Please ensure you details are correct"}, status: 502
            end
        end
    end

    def get_expense
        @employee = Current.user
        @expenses = Expense.where(employee_id: @employee[:id])
        render :get_expense, status: 201
    end

    def comment_expense
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
