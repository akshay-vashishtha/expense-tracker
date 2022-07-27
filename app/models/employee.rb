class Employee < ApplicationRecord
  belongs_to :admin
  has_many :expense, dependent: :destroy
  has_many :bills, dependent: :destroy
  validates_presence_of :email, :user_handle, :department
  validates :user_handle, uniqueness: true
  validates :email, uniqueness: true, format:{with: /[^@\s]+@[^@\s]+/, message: "Must be valid Email Address"}
end
