class ChangeTypes < ActiveRecord::Migration[7.0]
  def change
    change_column :expenses, :amount_approved, :decimal
    change_column :expenses, :amount_claimed, :decimal
    change_column :bills, :amount, :decimal
    change_column :bills, :invoice_number, :integer
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
