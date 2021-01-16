class AddColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :continue_check_box, :string
  end
end
