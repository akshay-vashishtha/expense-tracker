class Api::EmployeeController < ApplicationController
    def index 
        @users = Employee.all
        render json: @users
    end

    def show
        @employee = Employee.find_by(user_handle: params[:id])
        render :show
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
        @employee = Employee.find_by(user_handle: params[:id])
        @expenses = Expense.where(employee_id: @employee[:id])
        render :get_expense, status: 201
    end

    def comment_expense
        data = json_payload
        employee = Employee.find_by(user_handle: data["user_handle"])
        obj = {
            :user => data["user_handle"],
            :expense_id => data["expense_id"],
            :description => data["description"],
            :user_email => employee.email
        }
        Api::CommentController.add_comment(obj)
    end
end