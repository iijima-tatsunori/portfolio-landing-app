class AddColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :accounting, :boolean, default: false
  end
end
