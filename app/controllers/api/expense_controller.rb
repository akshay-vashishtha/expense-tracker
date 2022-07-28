class Api::ExpenseController < ApplicationController
    before_action :authorize_employee

    def show
        @expense = Expense.find_by(id: params[:id])
        if @expense != nil
            @bills = Bill.where(expense_id: params[:id])
            render :show    
        else 
            render json: {  "error": "expense not found!!"  }, status: 404
        end
    end
    
    def destroy
        expense = Expense.find(params[:id])
        if expense.employee_id == current_user.id
            if expense.destroy
                render json: { "Message": "expense deleted successfully"  }, status: 202
            else 
                render json: { "error": "failed to delete expense" }, status: 502
            end
        else
            render json: { "error": "unauthorized " }, status: :unauthorized
        end
    end
end
