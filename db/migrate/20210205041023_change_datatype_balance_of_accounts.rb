class ChangeDatatypeBalanceOfAccounts < ActiveRecord::Migration[5.1]
  def change
    change_column :accounts, :breakdown, :integer
    change_column :accounts, :amount, :integer
    change_column :accounts, :individual_amount, :integer
    change_column :accounts, :individual_amount_2, :integer
    change_column :accounts, :individual_amount_3, :integer
    change_column :accounts, :individual_amount_4, :integer
    change_column :accounts, :individual_amount_5, :integer
  end
end
