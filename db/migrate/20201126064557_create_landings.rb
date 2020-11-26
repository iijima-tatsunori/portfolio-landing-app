class CreateLandings < ActiveRecord::Migration[5.1]
  def change
    create_table :landings do |t|
      t.string :fishing_ground
      t.string :weather
      t.decimal :water_temperature
      t.string :fish_species
      t.decimal :landing_amount
      t.datetime :landing_datetime
      t.string :wind
      t.string :wave
      t.string :remarks
      t.string :size_etc
      t.integer :unit_price
      t.string :purchase
      t.string :shipping_destination
      
      t.timestamps
    end
  end
end
