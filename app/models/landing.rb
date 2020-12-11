class Landing < ApplicationRecord
  belongs_to :ground
  
  
  
  
  
  
  
  
  scope :search, -> (search_params) do
    return if search_params.blank?

    landing_date_is(search_params[:landing_date])
      .landing_fishing_ground_name_is(search_params[:landing_fishing_ground_name])
      .ground_id_is(search_params[:ground_id])
  end
  scope :landing_date_is, -> (landing_date) { where(landing_date: landing_date) if landing_date.present? }
  scope :landing_fishing_ground_name_is, -> (landing_fishing_ground_name) { where(landing_fishing_ground_name: landing_fishing_ground_name) if landing_fishing_ground_name.present? }
  scope :ground_id_is, -> (ground_id) { where(ground_id: ground_id) if ground_id.present? }
  
  
  
  
  
  
  
  
  
  
  
  
  validates :landing_date,      presence: true
                                
  validates :weather,           length: { maximum: 30 }
                                
  validates :water_temperature, length: { maximum: 30 }
                    
  validates :fish_species,      length: { maximum: 30 }
                    
  validates :landing_amount,    length: { maximum: 30 }
                                
  validates :wind,              length: { maximum: 30 }
  
  validates :wave,              length: { maximum: 30 }
                    
  validates :remarks,           length: { maximum: 300 }
  
  validates :size_etc,          length: { maximum: 30 }
  
  validates :unit_price,        length: { maximum: 30 }
  
  validates :purchase,          length: { maximum: 30 }
  
  validates :shipping_destination, length: { maximum: 30 }
  
  validates :landing_fishing_ground_name, length: { maximum: 30 }
                    
end
