class AddAuthToEmployee < ActiveRecord::Migration[7.0]
  def change
    add_column :employees, :password_digest, :string
    remove_column :employees, :admin_id
  end
end
