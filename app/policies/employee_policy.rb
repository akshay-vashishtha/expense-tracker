class EmployeePolicy < ApplicationPolicy
  def add_expense?
    !user[:terminated]
  end

  def get_expense?
    !user[:terminated]
  end

  def comment_expense?
    !user[:terminated]
  end

  def show?
    !user[:terminated]
  end
end
