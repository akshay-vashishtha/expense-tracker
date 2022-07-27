class Bill < ApplicationRecord
  belongs_to :employee
  belongs_to :expense
  validates_associated :employee, :expense
  validates_presence_of :amount, :attachments, :invoice_number, :title
end
