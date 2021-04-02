class CreateCompoundJournals < ActiveRecord::Migration[5.1]
  def change
    create_table :compound_journals do |t|
      t.string :account_title
      t.integer :amount
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
