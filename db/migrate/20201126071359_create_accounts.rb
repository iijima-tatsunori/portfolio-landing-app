class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.date :accounting_date

      t.timestamps
    end
  end
end
