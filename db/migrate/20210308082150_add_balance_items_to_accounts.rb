class AddBalanceItemsToAccounts < ActiveRecord::Migration[5.1]
  def change
     add_column :accounts, :balance_items, :integer
  end
end
