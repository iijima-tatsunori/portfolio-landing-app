class RemoveFishingGroundToLandings < ActiveRecord::Migration[5.1]
  def change
    remove_column :landings, :fishing_ground, :string
  end
end
