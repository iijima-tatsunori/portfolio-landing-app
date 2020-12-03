class RenameLandingDatetimeColumnToLandings < ActiveRecord::Migration[5.1]
  def change
    rename_column :landings, :landing_datetime, :landing_date
  end
end
