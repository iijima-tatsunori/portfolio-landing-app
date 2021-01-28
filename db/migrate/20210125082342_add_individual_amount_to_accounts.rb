class AddIndividualAmountToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :individual_amount, :decimal, precision: 12, scale: 2
    add_column :accounts, :individual_amount_2, :decimal, precision: 12, scale: 2
    add_column :accounts, :individual_amount_3, :decimal, precision: 12, scale: 2
    add_column :accounts, :individual_amount_4, :decimal, precision: 12, scale: 2
    add_column :accounts, :individual_amount_5, :decimal, precision: 12, scale: 2
    add_column :accounts, :account_title_2, :string
    add_column :accounts, :account_title_3, :string
    add_column :accounts, :account_title_4, :string
    add_column :accounts, :account_title_5, :string
  end
end
