class EmployeePolicy < ApplicationPolicy
  def index? 
    !user[:terminated]
  end

  def add_expense?
    !user[:terminated]
  end

  def show?
    !user[:terminated]
  end
end
