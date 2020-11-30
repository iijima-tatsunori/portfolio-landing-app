class AddColumnJournalDescriptionToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :journal_description, :string
  end
end
