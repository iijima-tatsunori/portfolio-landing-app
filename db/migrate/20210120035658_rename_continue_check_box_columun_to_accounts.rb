class RenameContinueCheckBoxColumunToAccounts < ActiveRecord::Migration[5.1]
  def change
    rename_column :accounts, :continue_check_box, :return_check_box
  end
end
