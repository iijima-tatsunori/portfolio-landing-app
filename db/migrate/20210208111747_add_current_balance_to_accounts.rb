class AddCurrentBalanceToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :current_balance, :integer
  end
end
