class CreateGrounds < ActiveRecord::Migration[5.1]
  def change
    create_table :grounds do |t|
      t.string :fishing_ground_name
      
      t.timestamps
    end
  end
end
