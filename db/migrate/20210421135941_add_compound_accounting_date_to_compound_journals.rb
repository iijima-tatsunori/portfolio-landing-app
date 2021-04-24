class AddCompoundAccountingDateToCompoundJournals < ActiveRecord::Migration[5.1]
  def change
    add_column :compound_journals, :compound_accounting_date, :date
  end
end
