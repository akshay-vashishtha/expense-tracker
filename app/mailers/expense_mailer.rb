class ExpenseMailer < ApplicationMailer
  def expense_processed
    mail(to: params[:user], subject: "Expense reimbursement procssed - Regarding")
  end
end
