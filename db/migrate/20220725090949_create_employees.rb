class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.references :admin, null: false, foreign_key: true
      t.string :user_handle
      t.string :email
      t.boolean :terminated
      t.decimal :phone_no
      t.string :gender
      t.string :department

      t.timestamps
    end
  end
end
