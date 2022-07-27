json.(@employee, :user_handle, :email)
json.expenses do 
    json.array! @expenses do |expense|
        json.(expense, :title, :amount_approved, :amount_claimed, :status)
    end
end
