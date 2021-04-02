class Account < ApplicationRecord
  has_many :compound_journals, dependent: :destroy
  accepts_nested_attributes_for :compound_journals, allow_destroy: true
  
  validate :future_day
  validate :individual_amount_present
  validate :individual_amount_2_present
  validate :account_title_2_present
  validate :individual_amount_3_present
  validate :account_title_3_present
  validate :individual_amount_4_present
  validate :account_title_4_present
  validate :individual_amount_5_present
  validate :account_title_5_present
  
  def future_day
    errors.add(:accounting_date," : 未来の日付は選択できません。") if Date.current < accounting_date
  end
  def individual_amount_present
    errors.add(:individual_amount," : 勘定科目が１つの場合、科目別単価は入力不要です。") if account_title.present? && individual_amount.present? && account_title_2.blank? && account_title_3.blank? && account_title_4.blank? && account_title_5.blank? && individual_amount_2.blank? && individual_amount_3.blank? &&  individual_amount_4.blank? &&  individual_amount_5.blank?
  end
  def individual_amount_2_present
    errors.add(:individual_amount_2,"入力エラー。") if individual_amount_2.blank? && account_title_2.present?# 勘定科目２が存在しないと、科目単価２も存在してはならない。
  end
  def individual_amount_3_present
    errors.add(:individual_amount_3,"入力エラー。") if individual_amount_3.blank? && account_title_3.present?# 勘定科目３が存在しないと、科目単価３も存在してはならない。
  end
  def individual_amount_4_present
    errors.add(:individual_amount_4,"入力エラー。") if individual_amount_4.blank? && account_title_4.present?# 勘定科目４が存在しないと、科目単価４も存在してはならない。
  end
  def individual_amount_5_present
    errors.add(:individual_amount_5,"入力エラー。") if individual_amount_5.blank? && account_title_5.present?# 勘定科目５が存在しないと、科目単価５も存在してはならない。
  end
  
  def account_title_2_present
    errors.add(:account_title_2,"入力エラー。") if account_title_2.blank? && individual_amount_2.present?# 科目単価２が存在しないと、勘定科目２も存在してはならない。
  end
  def account_title_3_present
    errors.add(:account_title_3,"入力エラー。") if account_title_3.blank? && individual_amount_3.present?# 勘定科目３が存在しないと、科目単価３も存在してはならない。
  end
  def account_title_4_present
    errors.add(:account_title_4,"入力エラー。") if account_title_4.blank? && individual_amount_4.present?# 勘定科目４が存在しないと、科目単価４も存在してはならない。
  end
  def account_title_5_present
    errors.add(:account_title_5,"入力エラー。") if account_title_5.blank? && individual_amount_5.present?# 勘定科目５が存在しないと、科目単価５も存在してはならない。
  end
  
  validates :accounting_date,            presence: true,
                                         length: { maximum: 30 }
                    
  validates :account_title,              length: { maximum: 30 }
  
  validates :account_title_2,            length: { maximum: 30 }
  
  validates :account_title_3,            length: { maximum: 30 }
  
  validates :account_title_4,            length: { maximum: 30 }
  
  validates :account_title_5,            length: { maximum: 30 }
  
  validates :individual_amount,          length: { maximum: 30 }
  
  validates :individual_amount_2,        length: { maximum: 30 }
  
  validates :individual_amount_3,        length: { maximum: 30 }
  
  validates :individual_amount_4,        length: { maximum: 30 }
  
  validates :individual_amount_5,        length: { maximum: 30 }
  
  validates :description,                length: { maximum: 100 }
                    
  validates :income,                     length: { maximum: 30 }
                    
  validates :expense,                    length: { maximum: 30 }
                    
  validates :deduction_balance,          length: { maximum: 30 }
                    
  validates :tax_rate,                   length: { maximum: 30 }
                    
  validates :subsidiary_journal_species, length: { maximum: 2}
                    
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
  
  validates :breakdown,                  length: { maximum: 300 }
  
  validates :amount,                     length: { maximum: 300 }
  
  validates :general_ledger_number,       length: { maximum: 30 }
  
  validates :journal_books_number,       length: { maximum: 30 }
  
  validates :notation,                   length: { maximum: 30 }
  
  validates :debit_account,              length: { maximum: 30 }
  
  validates :credit_account,             length: { maximum: 30 }
  
  validates :debit_amount,               length: { maximum: 30 }
  
  validates :credit_amount,              length: { maximum: 30 }
  
  validates :journal_balance,            length: { maximum: 30 }
  
  validates :journal_description,        length: { maximum: 30 }
 
end