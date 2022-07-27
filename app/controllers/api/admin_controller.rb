class Api::AdminController < ApplicationController
    before_action :authorize_admin, except: :create
    # before_action :find_user, except: %i[create index]
  
    def create 
        data = json_payload
        admin = Admin.new(data) 
        if admin.save
            render json: {"message": "successfully created admin"}, status: 201
        else 
            render json: {"error": "invalid request" }, status: 501
        end
    end

    def index 
        admins = Admin.all
        render json: admins
    end

    def search_expense
        @employee = Employee.find_by(user_handle: params[:id])
        @expenses = Expense.where(employee_id: @employee[:id])
        render :search_expense, status: 201
    end

    def list_pending_expense
        expenses = Expense.where(status: "pending")
        render json: expenses
    end

    def self.get_admin
        user = Admin.all 
        return user[0]
    end

    def self.add_employee(employee)
        user = Api::AdminController.get_admin()
        employee[:terminated] = false
    end

    def approve_bill
        bill = Bill.find(params[:id])
        if bill.status != "pending"
            render json: {  "message": "already processed"  }, status: 201
            return 
        end
        expense = Expense.find_by(id: bill[:expense_id])
        amount_approved = bill.amount + expense.amount_approved
        bill.update(status: "Approved")
        expense.update(amount_approved: amount_approved)
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
        puts json: employee
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

    def comment_expense
        data = json_payload
        data["user"] = "admin"
        data["user_email"] = "admin@yubi.com"
        Api::CommentController.add_comment(data)
        @expense = Expense.find_by(id: data["expense_id"])
        @employee = Employee.find_by(id: @expense.employee_id)
        user = {
            :user_email => @employee.email,
            :user_handle => @employee.user_handle,
            :title => @expense.title
        }
        Api::CommentController.notify_user(user)
        render json: { "message": "commented successfully" }, status: 201
    end

    def find_user
        @admin = Admin.find_by!(user_handle: params[:user_handle])
        rescue ActiveRecord::RecordNotFound
          render json: { errors: 'User not found' }, status: :not_found
      end
end
