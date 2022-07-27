class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :user
      t.string :description
      t.string :user_email
      t.references :expense, null: false, foreign_key: true

      t.timestamps
    end
  end
end
