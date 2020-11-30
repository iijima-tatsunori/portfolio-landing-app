class AccountsController < ApplicationController
  
  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  def show
  end
  
  def index
  end
  
  private

    def account_params
      params.require(:account).permit(:accounting_date,
                                      :account_title,
                                      :description,
                                      :income,
                                      :expense,
                                      :deduction_balance,
                                      :tax_rate,
                                      :subsidiary_journal_species,
                                      :check_number,
                                      :deposit,
                                      :drawer,
                                      :debit_credit,
                                      :balance,
                                      :customer,
                                      :receiving_method,
                                      :product_name,
                                      :quantity,
                                      :unit_price,
                                      :breakdown,
                                      :amount,
                                      :general_edger_number,
                                      :journal_books_number,
                                      :notation,
                                      :debit_account,
                                      :credit_account,
                                      :journal_description,
                                      :debit_amount,
                                      :credit_amount,
                                      :journal_balance
                                      )
    end
    
    
end
