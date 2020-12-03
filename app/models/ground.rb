class Ground < ApplicationRecord
  has_many :landings, dependent: :destroy
  
  validates :fishing_ground_name,    presence: true, length: { maximum: 30 }
end
