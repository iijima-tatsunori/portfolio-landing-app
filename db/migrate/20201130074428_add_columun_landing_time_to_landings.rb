class AddColumunLandingTimeToLandings < ActiveRecord::Migration[5.1]
  def change
    add_column :landings, :landing_time, :time
  end
end
