class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.references :employee, null: false, foreign_key: true
      t.integer :amount_claimed
      t.integer :amount_approved
      t.string :title
      t.string :status

      t.timestamps
    end
  end
end
