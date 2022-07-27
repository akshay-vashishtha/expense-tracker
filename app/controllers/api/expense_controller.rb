class Api::ExpenseController < ApplicationController
    def index 
        expense = Expense.all
        render json: expense
    end

    def show
        @expense = Expense.find_by(id: params[:id])
        if @expense != nil
            @bills = Bill.where(expense_id: params[:id])
            render :show    
        else 
            render json: {  "error": "expense not found!!"  }, status: 404
        end
    end

    def create
        data = json_payload
        expense = Expense.new(data)
        expense.amount_claimed = 0
        expense.amount_approved = 0
        expense.status = "pending"
        if expense.save
            render json: { "message": "expense created succesfully" }, status: 201
        else
            render json: {"error": "Please ensure you entered correct employee id"}, status: 502
        end
    end

    def destroy
        expense = Expense.find(params[:id])
        if expense.destroy
            render json: { "Message": "expense deleted successfully"  }, status: 202
        else 
            render json: { "error": "failed to delete expense" }, status: 502
        end
    end
end
