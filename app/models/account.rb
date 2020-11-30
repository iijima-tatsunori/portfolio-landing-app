class Account < ApplicationRecord
  validates :accounting_date,            presence: true,
                                         length: { maximum: 30 }
                    
  validates :account_title,              length: { maximum: 30 }
                    
  validates :description,                length: { maximum: 30 }
                    
  validates :income,                     length: { maximum: 30 }
                    
  validates :expense,                    length: { maximum: 30 }
                    
  validates :tax_rate,                   length: { maximum: 30 }
                    
  validates :subsidiary_journal_species, length: { maximum: 30 }
                    
  validates :check_number,               length: { maximum: 30 }
                    
  validates :deposit,                    length: { maximum: 30 }
  
  validates :drawer,                     length: { maximum: 30 }
  
  validates :debit_credit,               length: { maximum: 30 }
  
  validates :balance,                    length: { maximum: 30 }
  
  validates :customer,                   length: { maximum: 30 }
  
  validates :receiving_method,           length: { maximum: 30 }
  
  validates :product_name,               length: { maximum: 30 }
  
  validates :quantity,                   length: { maximum: 30 }
  
  validates :unit_price,                 length: { maximum: 30 }
  
  validates :breakdown,                  length: { maximum: 30 }
  
  validates :amount,                     length: { maximum: 30 }
  
  validates :general_edger_number,       length: { maximum: 30 }
  
  validates :journal_books_number,       length: { maximum: 30 }
  
  validates :notation,                   length: { maximum: 30 }
  
  validates :debit_account,              length: { maximum: 30 }
  
  validates :credit_account,             length: { maximum: 30 }
  
  validates :debit_amount,               length: { maximum: 30 }
  
  validates :credit_amount,              length: { maximum: 30 }
  
  validates :journal_balance,            length: { maximum: 30 }
  
  validates :journal_description,        length: { maximum: 30 }
 
end