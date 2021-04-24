class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy,
                                     :purchasing_show, :purchasing_edit, :purchasing_update, :purchasing_destroy,
                                     :cash_show, :cash_edit, :cash_update, :cash_destroy,
                                     :current_show, :current_edit, :current_update, :current_destroy,
                                     :transfer_slip_edit, :transfer_slip_update, :transfer_slip_destroy]
  
  before_action :logged_in_user, only: [:new, :create, :show, :index, :edit, :update, :destroy,
                                        :purchasing_new, :purchasing_create, :purchasing_show, :purchasing_index, :purchasing_edit, :purchasing_update, :purchasing_destroy,
                                        :cash_new, :cash_create, :cash_show, :cash_index, :cash_edit, :cash_update, :cash_destroy,
                                        :current_new, :current_create, :current_show, :current_index, :current_edit, :current_update, :current_destroy,
                                        :all_general_ledger, :master_general_ledger, :sub_master_general_ledger,
                                        :general_ledger, :purchasing_general_ledger, :cash_general_ledger, :current_general_ledger,
                                        :journal_books, :profit_and_loss_statement, :balance_sheet,
                                        :transfer_slip_new, :transfer_slip_create, :transfer_slip_edit, :transfer_slip_update, :transfer_slip_destroy]
                                        
  before_action :admin_and_accounting_user, only: [:new, :create, :show, :index, :edit, :update, :destroy,
                                                   :purchasing_new, :purchasing_create, :purchasing_show, :purchasing_index, :purchasing_edit, :purchasing_update, :purchasing_destroy,
                                                   :cash_new, :cash_create, :cash_show, :cash_index, :cash_edit, :cash_update, :cash_destroy,
                                                   :current_new, :current_create, :current_show, :current_index, :current_edit, :current_update, :current_destroy,
                                                   :all_general_ledger, :master_general_ledger, :sub_master_general_ledger,
                                                   :general_ledger, :purchasing_general_ledger, :cash_general_ledger, :current_general_ledger,
                                                   :journal_books, :profit_and_loss_statement, :balance_sheet,
                                                   :transfer_slip_new, :transfer_slip_create, :transfer_slip_edit, :transfer_slip_update, :transfer_slip_destroy]
  
  before_action :set_one_month, only: [:new, :create, :show, :index, :edit, :update, :destroy,
                                       :purchasing_new, :purchasing_create, :purchasing_show, :purchasing_index, :purchasing_edit, :purchasing_update, :purchasing_destroy,
                                       :cash_new, :cash_create, :cash_show, :cash_index, :cash_edit, :cash_update, :cash_destroy,
                                       :current_new, :current_create, :current_show, :current_index, :current_edit, :current_update, :current_destroy,
                                       :all_general_ledger, :master_general_ledger, :sub_master_general_ledger,
                                       :general_ledger, :purchasing_general_ledger, :cash_general_ledger, :current_general_ledger,
                                       :journal_books, :profit_and_loss_statement, :balance_sheet,
                                       :transfer_slip_new, :transfer_slip_create, :transfer_slip_edit, :transfer_slip_update, :transfer_slip_destroy]
                                       
  before_action :transfer_slip_account_title, only: [:transfer_slip_new, :transfer_slip_create, :transfer_slip_edit]
  before_action :assets_account_title, only: [:transfer_slip_new, :transfer_slip_create, :transfer_slip_edit, :transfer_slip_update, :transfer_slip_destroy]
  before_action :liabilities_account_title, only: [:transfer_slip_new, :transfer_slip_create, :transfer_slip_edit, :transfer_slip_update, :transfer_slip_destroy]
  before_action :cost_account_title, only: [:transfer_slip_new, :transfer_slip_create, :transfer_slip_edit, :transfer_slip_update, :transfer_slip_destroy]
  before_action :revenue_account_title, only: [:transfer_slip_new, :transfer_slip_create, :transfer_slip_edit, :transfer_slip_update, :transfer_slip_destroy]
  before_action :tax_rate, only: [:transfer_slip_new, :transfer_slip_create, :transfer_slip_edit, :transfer_slip_update, :transfer_slip_destroy]
  before_action :sub_account_title, only: [:transfer_slip_new, :transfer_slip_create, :transfer_slip_edit, :transfer_slip_update, :transfer_slip_destroy]
  
  # --------------------------振替伝票作成-------------------------
  def transfer_slip_new
    @account = Account.new
    @compound_journals = @account.compound_journals.build
  end
  
  def transfer_slip_create
    @account = Account.new(transfer_slip_account_params)
    if @account.save
      flash[:success] = "#{l(@account.accounting_date, format: :long)}の帳簿を新規作成しました。"
      redirect_to transfer_slip_new_accounts_url
    else
      flash[:danger] = "入力エラー。"
      redirect_to transfer_slip_new_accounts_url
    end
  end
  
  def transfer_slip_edit
    @compounds = @account.compound_journals.where(account_id: @account.id)
  end

  def transfer_slip_update
    if @account.update_attributes(transfer_slip_account_params)
      flash[:success] = "#{l(@account.accounting_date, format: :long)}のデータを変更しました。"
      redirect_to journal_books_accounts_url(accounting_date: @account.accounting_date)
    else
      flash[:danger] = "入力エラー。"
      redirect_to journal_books_accounts_url(accounting_date: @account.accounting_date)
    end
  end

  def transfer_slip_destroy
    @account.destroy
    flash[:success] = "#{l(@account.accounting_date, format: :long)}のデータを一件削除しました。"
    redirect_to journal_books_accounts_url(accounting_date: @account.accounting_date)
  end
  # -------------------------------------------------------------
  
  # --------------------------総勘定元帳----------------------------
  def all_general_ledger
  end
  
  def master_general_ledger
    @param_account_title = params[:param_account_title]
    @general_ledger_accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: @param_account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: @param_account_title})).distinct.merge(Account.order("accounts.accounting_date ASC"))
    @amount_carried_forward = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date < @first_day
    end
    @this_month_last_balance = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date <= @last_day
    end
  end
  
  def sub_master_general_ledger
    @param_account_title = params[:param_account_title]
    @general_ledger_accounts = Account.joins(:compound_journals).where(compound_journals: {sub_account_title: @param_account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_sub_account_title: @param_account_title})).distinct.merge(Account.order("accounts.accounting_date ASC"))
    @amount_carried_forward = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date < @first_day
    end
    @this_month_last_balance = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date <= @last_day
    end
  end
  # ----------------------------------------------------------------
  
  # --------------------------仕訳帳--------------------------------
  def journal_books
    @journal_accounts = Account.includes(:compound_journals).merge(Account.order("accounts.accounting_date ASC")).merge(Account.order("accounts.subsidiary_journal_species ASC"))
  end
  # ----------------------------------------------------------------

 # --------------------------損益計算書--------------------------------
  def profit_and_loss_statement
    @accounts = Account.where(subsidiary_journal_species: 4).merge(Account.order("accounts.accounting_date ASC")).merge(Account.order("accounts.subsidiary_journal_species ASC"))
    @this_year_first_balance = @accounts.select do |c_a|
      c_a.accounting_date >= @this_year.first
    end
    @this_year_last_balance = @accounts.select do |c_a|
      c_a.accounting_date <= @this_year.last
    end
    
    @purchasing_accounts = Account.where(subsidiary_journal_species: 3).merge(Account.order("accounts.accounting_date ASC")).merge(Account.order("accounts.subsidiary_journal_species ASC"))
    @this_year_first_purchasing_balance = @purchasing_accounts.select do |c_a|
      c_a.accounting_date >= @this_year.first
    end
    @this_year_last_purchasing_balance = @purchasing_accounts.select do |c_a|
      c_a.accounting_date <= @this_year.last
    end
    
    @profit_and_loss_statement_accounts = Account.where(accounting_date: @first_day.all_year).merge(Account.order("accounts.accounting_date ASC")).merge(Account.order("accounts.subsidiary_journal_species ASC"))
    
  end
  # ----------------------------------------------------------------

 # --------------------------貸借対照表--------------------------------
  def balance_sheet
    @balance_sheet_accounts = Account.all.merge(Account.order("accounts.accounting_date ASC")).merge(Account.order("accounts.subsidiary_journal_species ASC"))
    @cash_accounts = Account.where("account_title = '現金'").or(Account.where("account_title_2 = '現金'")).or(Account.where("account_title_3 = '現金'")).or(Account.where("account_title_4 = '現金'").where("account_title_5 = '現金'")).or(Account.where(subsidiary_journal_species: 1)).merge(Account.order("accounts.accounting_date ASC")).merge(Account.order("accounts.subsidiary_journal_species ASC"))
    @current_accounts = Account.where("account_title = '預金'").or(Account.where("account_title_2 = '預金'")).or(Account.where("account_title_3 = '預金'")).or(Account.where("account_title_4 = '預金'").where("account_title_5 = '預金'")).or(Account.where(subsidiary_journal_species: 2)).merge(Account.order("accounts.accounting_date ASC")).merge(Account.order("accounts.subsidiary_journal_species ASC"))
  end
  # ----------------------------------------------------------------

  private
    # ------------------------strong_parameter-----------------------
    def transfer_slip_account_params
      params.require(:account).permit(:accounting_date,
                                      compound_journals_attributes: [
                                      :id,
                                      :account_title,
                                      :amount,
                                      :tax_rate,
                                      :description,
                                      :sub_account_title,
                                      :right_account_title,
                                      :right_amount,
                                      :right_tax_rate,
                                      :right_sub_account_title,
                                      :_destroy
                                      ])
    end
    # --------------------------------------------------------------

end
