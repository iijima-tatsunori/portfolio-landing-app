class Landing < ApplicationRecord
  belongs_to :ground
  
  validates :landing_date,      presence: true
                                
  validates :landing_time,      presence: true
                                
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
                    
end
