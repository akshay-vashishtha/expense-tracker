require "test_helper"

class ExpenseMailerTest < ActionMailer::TestCase
  test "expense_processed" do
    mail = ExpenseMailer.expense_processed
    assert_equal "Expense processed", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
