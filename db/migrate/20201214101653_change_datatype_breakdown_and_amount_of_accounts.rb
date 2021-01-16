class ChangeDatatypeBreakdownAndAmountOfAccounts < ActiveRecord::Migration[5.1]
  def change
    change_column :accounts, :breakdown, :decimal
    change_column :accounts, :amount, :decimal
  end
end
