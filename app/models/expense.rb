class Expense < ApplicationRecord
  belongs_to :employee
  has_many :bills, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates_associated :employee
  validates_presence_of :status
end
