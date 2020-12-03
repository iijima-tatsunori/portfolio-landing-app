class Landing < ApplicationRecord
  belongs_to :ground
  
  validates :landing_date,      presence: true,
                                length: { maximum: 30 }
                                
  validates :landing_time,      presence: true,
                                length: { maximum: 30 }
                                
  validates :weather,           length: { maximum: 30 },
                                allow_nil: true
                    
  validates :water_temperature, length: { maximum: 30 },
                                allow_blank: true
                    
  validates :fish_species,      length: { maximum: 30 },
                                allow_blank: true
                    
  validates :landing_amount,    length: { maximum: 30 },
                                allow_blank: true
                                
  validates :wind,              length: { maximum: 30 },
                                allow_blank: true
                    
  validates :wave,              length: { maximum: 30 },
                                allow_blank: true
                    
  validates :remarks,           length: { maximum: 300 },
                                allow_blank: true
  
  validates :size_etc,          length: { maximum: 30 },
                                allow_blank: true
  
  validates :unit_price,        length: { maximum: 30 },
                                allow_blank: true
  
  validates :purchase,          length: { maximum: 30 },
                                allow_blank: true
  
  validates :shipping_destination, length: { maximum: 30 },
                                   allow_blank: true
                    
                    
                    
end
