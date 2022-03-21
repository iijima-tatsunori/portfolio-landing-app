class Account < ApplicationRecord
  has_many :compound_journals, dependent: :destroy
  accepts_nested_attributes_for :compound_journals, allow_destroy: true
  
  validates :accounting_date, presence: true
  mount_uploader :image, ImageUploader
end