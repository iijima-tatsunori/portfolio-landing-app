class ChangeDatatypeQuantityToAccounts < ActiveRecord::Migration[5.1]
  def change
    change_column :accounts, :quantity, :decimal, precision: 12, scale: 2
    change_column :accounts, :breakdown, :decimal, precision: 12, scale: 2
    change_column :accounts, :amount, :decimal, precision: 12, scale: 2
  end
end
