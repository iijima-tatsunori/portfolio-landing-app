class ChangeDataLandingDatetimeToLanding < ActiveRecord::Migration[5.1]
  def change
    change_column :landings, :landing_datetime, :date
  end
end
