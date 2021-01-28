class RenameGeneralEdgerNumberColumunToAccounts < ActiveRecord::Migration[5.1]
  def change
    rename_column :accounts, :general_edger_number, :general_ledger_number
  end
end
