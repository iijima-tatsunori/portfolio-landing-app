class ChangeDatatypeWaterTemperatureToLandings < ActiveRecord::Migration[5.1]
  def change
    change_column :landings, :water_temperature, :decimal, precision: 12, scale: 2
    change_column :landings, :landing_amount, :decimal, precision: 12, scale: 2
  end
end
