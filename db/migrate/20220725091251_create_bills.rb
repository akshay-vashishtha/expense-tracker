class CreateBills < ActiveRecord::Migration[7.0]
  def change
    create_table :bills do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :expense, null: false, foreign_key: true
      t.integer :amount
      t.string :status
      t.string :attachments
      t.decimal :invoice_number
      t.string :title

      t.timestamps
    end
  end
end
