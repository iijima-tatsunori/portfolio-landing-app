class AddRightAccountTitleToCompoundJournals < ActiveRecord::Migration[5.1]
  def change
    add_column :compound_journals, :right_account_title, :string
    add_column :compound_journals, :right_tax_rate, :integer
    add_column :compound_journals, :right_sub_account_title, :string
    add_column :compound_journals, :right_amount, :integer
  end
end
