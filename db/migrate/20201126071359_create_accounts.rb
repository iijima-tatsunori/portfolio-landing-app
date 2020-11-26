class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.date :accounting_date
      t.string :account_title
      t.string :description
      t.integer :income
      t.integer :expense
      t.integer :deduction_balance
      t.integer :tax_rate
      t.integer :subsidiary_journal_species
      t.string :check_number
      t.integer :deposit
      t.integer :drawer
      t.integer :debit_credit
      t.integer :balance
      t.string :customer
      t.string :receiving_method
      t.string :product_name
      t.decimal :quantity
      t.integer :unit_price
      t.integer :breakdown
      t.integer :amount 
      t.integer :general_edger_number
      t.integer :journal_books_number
      t.string :notation
      t.string :debit_account
      t.string :credit_account
      t.string :description
      t.integer :debit_amount
      t.integer :credit_amount
      t.integer :journal_balance

      t.timestamps
    end
  end
end
