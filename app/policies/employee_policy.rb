class EmployeePolicy < ApplicationPolicy
  # class Scope < Scope
  #   # NOTE: Be explicit about which records you allow access to!
  #   def resolve
  #       scope.all
  #   end
  # end

  def index? 
    !@user[:terminated]?
  end

  def show? 
    # puts "this point"
    # puts json: @user
    return !@employee["terminated"]
  end
end
