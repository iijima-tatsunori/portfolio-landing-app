class AddImageToCompoundJournals < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :image, :string
  end
end
