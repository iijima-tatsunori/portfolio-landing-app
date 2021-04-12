class CompoundJournal < ApplicationRecord
  belongs_to :account, optional: true
end
