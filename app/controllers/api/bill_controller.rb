require 'uri'
require 'net/http'

class Api::BillController < ApplicationController
    before_action :authorize_employee
    def index
        bills = Bill.all
        render json: bills
    end

    def show 
        @bill = Bill.find(params[:id])
        render :show
    end

    def create
        data = json_payload
        if invoice_validator (data["invoice_number"])
            bill = Bill.new(data)
            expense = Expense.find_by(id: data["expense_id"])
            amount_claimed = expense.amount_claimed + bill.amount
            if bill.save
                expense.update(amount_claimed: amount_claimed)
                render json: { "message": "bill created succesfully" }, status: 201
            else
                render json: {"error": "Please ensure you entered correct employee id"}, status: 502
            end
        else
            render json: {  "error": "invoice number is not valid "  }, status: 502
        end
    end

    def destroy
        bill = Bill.find(params[:id])
        expense = Expense.find_by(id: bill.expense_id)
        amount_claimed = expense.amount_claimed - bill.amount
        if amount_claimed < 0
            amount_claimed = 0
        end
        if bill.destroy
            expense.update(amount_claimed: amount_claimed)
            render json: { "Message": "bill deleted successfully"  }, status: 202
        else 
            render json: { "error": "failed to delete bill" }, status: 502
        end
    end

    def invoice_validator (invoice_id)
        obj = {
            "invoice_id" => invoice_id
        }
        url = URI("https://my.api.mockaroo.com/invoices.json")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(url)
        request["X-API-Key"] = "b490bb80"
        request["Content-Type"] = "application/json"
        request.body = JSON.dump(obj)
        
        response = https.request(request)
        return HashWithIndifferentAccess.new(JSON.parse(response.body))["status"]
    end
end
