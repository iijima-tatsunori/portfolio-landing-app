class AddTaxTa < ActiveRecord::Migration[5.1]
  def change
    add_column :compound_journals, :tax_rate, :integer
    add_column :compound_journals, :description, :string
    add_column :compound_journals, :sub_account_title, :string
  end
end
