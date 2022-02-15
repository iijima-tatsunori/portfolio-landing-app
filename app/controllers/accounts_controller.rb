class AccountsController < ApplicationController
  require 'csv'
  before_action :set_account, only: [:transfer_slip_edit, :transfer_slip_update, :transfer_slip_destroy]
  
  before_action :set_accounts, only: [:journal_books, :balance_sheet, :profit_and_loss_statement]
  
  before_action :logged_in_user, only: [:all_general_ledger, :master_general_ledger, :sub_master_general_ledger,
                                        :journal_books, :balance_sheet, :profit_and_loss_statement,
                                        :transfer_slip_new, :transfer_slip_create, :transfer_slip_edit, :transfer_slip_update, :transfer_slip_destroy]

  before_action :admin_and_accounting_user, only: [:all_general_ledger, :master_general_ledger, :sub_master_general_ledger,
                                                   :journal_books, :balance_sheet, :profit_and_loss_statement,
                                                   :transfer_slip_new, :transfer_slip_create, :transfer_slip_edit, :transfer_slip_update, :transfer_slip_destroy]

  before_action :set_one_month, only: [:all_general_ledger, :master_general_ledger, :sub_master_general_ledger,
                                       :journal_books, :balance_sheet, :profit_and_loss_statement,
                                       :transfer_slip_new, :transfer_slip_create, :transfer_slip_edit, :transfer_slip_update, :transfer_slip_destroy]

  before_action :transfer_slip_account_titles, only: [:transfer_slip_new, :transfer_slip_create, :transfer_slip_edit]
  before_action :tax_rate_arys, only: [:transfer_slip_new, :transfer_slip_create, :transfer_slip_edit, :transfer_slip_update, :transfer_slip_destroy]
  before_action :sub_account_titles, only: [:transfer_slip_new, :transfer_slip_create, :transfer_slip_edit, :transfer_slip_update, :transfer_slip_destroy]
  
  before_action :left_account_titles, only: :all_general_ledger
  before_action :right_account_titles, only: :all_general_ledger
  
  before_action :amount_of_sales, only: [:profit_and_loss_statement, :balance_sheet]
  before_action :cost_of_sales, only: [:profit_and_loss_statement, :balance_sheet]
  before_action :administrative_expenses, only: [:profit_and_loss_statement, :balance_sheet]
  before_action :non_operating_income, only: [:profit_and_loss_statement, :balance_sheet]
  before_action :non_operating_expenses, only: [:profit_and_loss_statement, :balance_sheet]
  before_action :extraordinary_gains, only: [:profit_and_loss_statement, :balance_sheet]
  before_action :extraordinary_loss, only: [:profit_and_loss_statement, :balance_sheet]
  before_action :corporate_inhabitant_and_enterprise_taxes, only: [:profit_and_loss_statement, :balance_sheet]
  
  
  
  before_action :cash_deposits, only: :balance_sheet
  before_action :trade_receivables, only: :balance_sheet
  before_action :inventories, only: :balance_sheet
  before_action :other_current_assets, only: :balance_sheet
  before_action :tangible_fixed_assets, only: :balance_sheet
  before_action :intangible_fixed_assets, only: :balance_sheet
  before_action :deferred_assets, only: :balance_sheet
  before_action :accounts_payable_trades, only: :balance_sheet
  before_action :other_current_liabilities, only: :balance_sheet
  before_action :fixed_liabilities, only: :balance_sheet
  before_action :capital_stocks, only: :balance_sheet
  before_action :retained_earnings, only: :balance_sheet
  
  def csv
  end
  
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
  
  # --------------------------仕訳帳--------------------------------
  def journal_books
  end
  
  def csv_journal_books
    @ary_date = params[:first].to_date..params[:last].to_date
    @csv_accounts = Account.includes(:compound_journals).where(accounting_date: @ary_date).merge(Account.order("accounts.accounting_date ASC"))
    respond_to do |format|
      format.html
      format.csv do |csv|
        send_accounts_csv(@csv_accounts)
      end
    end
  end
  # ----------------------------------------------------------------

  # --------------------------総勘定元帳----------------------------
  def all_general_ledger
  end

  def master_general_ledger
    @carried_forward_balance = 0
    @this_month_last_balance = 0
    @param_account_title = params[:param_account_title]
    @general_ledger_accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: @param_account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: @param_account_title})).distinct.merge(Account.order("accounts.accounting_date ASC"))
  end

  def sub_master_general_ledger
    @sub_carried_forward_balance = 0
    @sub_this_month_last_balance = 0
    @param_account_title = params[:param_account_title]
    @general_ledger_accounts = Account.joins(:compound_journals).where(compound_journals: {sub_account_title: @param_account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_sub_account_title: @param_account_title})).distinct.merge(Account.order("accounts.accounting_date ASC"))
  end
  # ----------------------------------------------------------------

  # --------------------------貸借対照表--------------------------------
  def balance_sheet
  end
  # ----------------------------------------------------------------

  # --------------------------損益計算書--------------------------------
  def profit_and_loss_statement
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

    # ------------------------仕訳帳CSV出力-----------------------
    def send_accounts_csv(accounts)
      csv_data = CSV.generate do |csv|
        column_names = %w(日付 摘要 勘定科目 借方金額 勘定科目 貸方金額)
        csv << column_names
        accounts.each do |account|
          account.compound_journals.each do |compound_journal|
            column_values = [
              account.accounting_date,
              compound_journal.description,
              compound_journal.account_title,
              compound_journal.amount,
              compound_journal.right_account_title,
              compound_journal.right_amount
            ]
          
          csv << column_values
        end
        end
      end
      send_data(csv_data, filename: "#{l(Date.current, format: :long)}CSV出力、仕訳帳一覧.csv")
    end
end
