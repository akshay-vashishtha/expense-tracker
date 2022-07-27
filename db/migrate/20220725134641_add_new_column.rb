class AddNewColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :admins, :admin, :boolean
  end
end
