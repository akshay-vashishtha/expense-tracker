json.(@employee, :user_handle, :email)
json.expenses do 
    json.array! @expenses do |expense|
        json.(expense, :title, :created_at, :status, :amount_claimed, :amount_approved)
    end
end