class AddCreditBalanceToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :general_account_balance, :integer
    add_column :accounts, :general_purchasing_balance, :integer
    add_column :accounts, :general_cash_balance, :integer
    add_column :accounts, :general_current_balance, :integer
    add_column :accounts, :general_payable_balance, :integer
    add_column :accounts, :general_recievable_balance, :integer
    add_column :accounts, :general_profit_and_loss_balance, :integer
    add_column :accounts, :general_capital_stock_balance, :integer
  end
end
