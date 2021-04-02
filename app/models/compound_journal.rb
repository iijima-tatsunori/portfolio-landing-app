class CompoundJournal < ApplicationRecord
  belongs_to :account
  
  validates :account_title, presence: true,
                            length: { maximum: 30 }
end
