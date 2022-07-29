class Api::EmployeeController < ApplicationController
    before_action :authorize_employee, except: :create

    def show
        begin
            authorize current_user
            if current_user.user_handle == params[:id]
                @employee = Employee.find_by(user_handle: params[:id])
                render :show
            else
                render json: {  "error": "Forbidden"  }, status: :forbidden 
            end
        rescue Pundit::NotAuthorizedError => e
            render json: { "message": "#{e.message}" }, status: :unauthorized
        end
    end

    def add_expense
        begin
            authorize current_user
            data = json_payload
            expense = Expense.new(data)
            expense.employee_id = current_user[:id]
            expense.amount_claimed = 0
            expense.amount_approved = 0
            expense.status = "pending"
            expense.save
            render json: { "message": "expense created succesfully", "expense": expense }, status: 201
        rescue Pundit::NotAuthorizedError => e
            render json: { "message": "#{e.message}" }, status: :unauthorized
        rescue => e
            render json: {"error": "Please ensure you entered correct employee id"}, status: :unauthorized
        end
    end

    def get_expense
        begin 
            authorize current_user
            @employee = current_user
            @expenses = @employee.expense
            render :get_expense, status: 201
        rescue Pundit::NotAuthorizedError => e
            render json: { "message": "#{e.message}" }, status: :unauthorized
        end
    end
end
