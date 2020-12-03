class AddGroundIdToLandings < ActiveRecord::Migration[5.1]
  def change
    add_reference :landings, :ground, foreign_key: true
  end
end
