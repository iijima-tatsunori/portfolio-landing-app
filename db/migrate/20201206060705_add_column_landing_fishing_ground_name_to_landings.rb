class AddColumnLandingFishingGroundNameToLandings < ActiveRecord::Migration[5.1]
  def change
    add_column :landings, :landing_fishing_ground_name, :string
  end
end
