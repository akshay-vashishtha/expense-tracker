json.(@expense, :title, :status, :amount_claimed, :amount_approved)
json.bills do 
    json.array! @bills do |bill|
        json.(bill, :id, :title, :amount, :status, :invoice_number, :attachments, :status)
    end
end
