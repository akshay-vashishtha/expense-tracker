# Preview all emails at http://localhost:3000/rails/mailers/expense_mailer
class ExpenseMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/expense_mailer/expense_processed
  def expense_processed
    ExpenseMailer.expense_processed
  end

end
