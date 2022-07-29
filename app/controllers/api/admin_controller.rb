class Api::AdminController < ApplicationController
    before_action :authorize_admin, except: :create
    before_action :find_user, except: %i[create index]

    def create
        data = json_payload
        if Admin.exists?(user_handle: data["user_handle"])
            render json: {"error": "user_handle already exits"}, status: :forbidden
        else 
            admin = Admin.new(data) 
            if admin.save
                render json: {"message": "successfully created admin"}, status: :created
            else 
                render json: {"error": "invalid request" }, status: :forbidden
            end
        end
    end

    def index 
        admins = Admin.all
        render json: admins
    end

    def show
        begin
            admin = Admin.find_by!(id: params[:id])
            render json: admin
        rescue ActiveRecordError::RecordNotFound => error
            render json: {  "Error": error.message  }, status: :not_found
        end
    end

    def search_expense
        @employee = Employee.find_by(user_handle: params[:id])
        @expenses = @employee.expense
        render :search_expense, status: 201
    end

    def list_pending_expense
        expenses = Expense.where(status: "pending")
        render json: expenses
    end

    def add_employee
        data = json_payload
        data[:terminated] = false
        if Employee.exists?(:user_handle => data[:user_handle])
            render json: {"error": "Already exits"}
        else
            employee = Employee.new(data)
            if employee.save
                render json: {"message": "employee created succesfully" }, status: 201
            else
                render json: {"error": "Please ensure you details are correct"}, status: 502
            end
        end
    end

    def approve_bill
        bill = Bill.find(params[:id])
        if bill.status != "pending"
            render json: {  "message": "already processed"  }, status: 201
            return 
        end
        # expense = Expense.find_by(id: bill[:expense_id])
        amount_approved = bill.amount + bill.expense.amount_approved
        bill.update(status: "Approved")
        bill.expense.update(amount_approved: amount_approved)
        mandate_expense(bill.expense_id)
        render json: {  "message": "bill has been approved successfully"  }, status: 201
    end

    def reject_bill
        bill = Bill.find(params[:id])
        if bill.status != "pending"
            render json: {  "message": "already processed"  }, status: 201
            return 
        end
        bill.update(status: "Reject")
        mandate_expense(bill.expense_id)
        render json: {  "message": "bill has been rejected successfully"  }, status: 201
    end

    def terminate_employee
        data = json_payload
        employee = Employee.find_by(user_handle: data[:employee_handle])
        begin 
            employee.update(terminated: true)
            render json: {  "message": "Employee #{employee.user_handle} has been terminated"   }, status: :ok
        rescue => e
            render json: {  errors: e.message   }, status: :expectation_failed
        end
    end

    def mandate_expense (expense_id)
        bills = Bill.where(expense_id: expense_id)
        count = 0
        bills.each do |bill|
            count += (bill.status != "pending" ? 1 : 0)
        end
        if count == bills.length 
            expense = Expense.find_by(id: expense_id)
            employee = Employee.find_by(id: expense.employee_id)
            rejected_amount = expense.amount_claimed - expense.amount_approved
            expense.update(status: "processed")
            ExpenseMailer.with(user: employee.email, title: expense.title, applied_amount: expense.amount_claimed, approved_amount: expense.amount_approved, rejected_amount: rejected_amount).expense_processed.deliver_now
        end
    end

    def list_employee
        employees = Employee.all
        render json: employees
    end

    def list_expense
        expenses = Expense.all
        render json: expenses
    end

    def list_bills
        bills = Bill.all
        render json: bills
    end

    def find_user
        begin
            @admin = Admin.find_by!(user_handle: Current.user[:user_handle])
        rescue ActiveRecord::RecordNotFound => error
          render json: { errors: error.message }, status: :not_found
        end
    end
end
