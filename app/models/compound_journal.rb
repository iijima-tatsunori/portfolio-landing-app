class CompoundJournal < ApplicationRecord
  belongs_to :account, optional: true

  validates :amount, presence: true
  validates :right_amount, presence: true
  validates :account_title, presence: true
  validates :right_account_title, presence: true
  
  validates :description, length: { maximum: 200 }
end
