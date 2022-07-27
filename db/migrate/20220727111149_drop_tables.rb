class DropTables < ActiveRecord::Migration[7.0]
  def change
    drop_table :froms
    drop_table :tos
  end
end
