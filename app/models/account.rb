class Account < ApplicationRecord
  
  
  scope :search, -> (search_params) do
    return if search_params.blank?

    accounting_date_is(search_params[:accounting_date])
    .customer_like(search_params[:customer])
      
  end
  scope :accounting_date_is, -> (accounting_date) { where(accounting_date: accounting_date) if accounting_date.present? }
  scope :customer_like, -> (customer) { where('customer LIKE ?', "%#{customer}%") if customer.present? }
  
  
  
  
  
  scope :purchasign_search, -> (search_params) do
    return if search_params.blank?

    accounting_date_is(search_params[:accounting_date])
    .customer_like(search_params[:customer])
      
  end
  scope :accounting_date_is, -> (accounting_date) { where(accounting_date: accounting_date) if accounting_date.present? }
  scope :customer_like, -> (customer) { where('customer LIKE ?', "%#{customer}%") if customer.present? }
  
  
  
  
  scope :cash_search, -> (search_params) do
    return if search_params.blank?

    accounting_date_is(search_params[:accounting_date])
    .account_title_like(search_params[:account_title])
      
  end
  scope :accounting_date_is, -> (accounting_date) { where(accounting_date: accounting_date) if accounting_date.present? }
  scope :account_title_like, -> (account_title) { where('account_title LIKE ?', "%#{account_title}%") if account_title.present? }
  
  
  
  
  
  scope :current_search, -> (search_params) do
    return if search_params.blank?

    accounting_date_is(search_params[:accounting_date])
    .check_number_like(search_params[:check_number])
      
  end
  scope :accounting_date_is, -> (accounting_date) { where(accounting_date: accounting_date) if accounting_date.present? }
  scope :check_number_like, -> (check_number) { where('check_number LIKE ?', "%#{check_number}%") if check_number.present? }
  
  
  
  
  
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