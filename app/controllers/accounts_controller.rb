class AccountsController < ApplicationController
  before_action :set_account, only: [:edit, :update, :destroy,
                                     :purchasing_edit, :purchasing_update, :purchasing_destroy,
                                     :cash_edit, :cash_update, :cash_destroy,
                                     :current_edit, :current_update, :current_destroy]
  
  before_action :logged_in_user, only: [:new, :create, :show, :index, :edit, :update, :destroy, :journal_books, :general_edger,
                                        :purchasing_new, :purchasing_create, :purchasing_show, :purchasing_index, :purchasing_edit, :purchasing_update, :purchasing_destroy,
                                        :cash_new, :cash_create, :cash_show, :cash_index, :cash_edit, :cash_update, :cash_destroy,
                                        :current_new, :current_create, :current_show, :current_index, :current_edit, :current_update, :current_destroy]
                                        
  before_action :admin_and_accounting_user, only: [:new, :create, :show, :index, :edit, :update, :destroy, :journal_books, :general_edger,
                                                   :purchasing_new, :purchasing_create, :purchasing_show, :purchasing_index, :purchasing_edit, :purchasing_update, :purchasing_destroy,
                                                   :cash_new, :cash_create, :cash_show, :cash_index, :cash_edit, :cash_update, :cash_destroy,
                                                   :current_new, :current_create, :current_show, :current_index, :current_edit, :current_update, :current_destroy]
  
  before_action :set_one_month, only: [:new, :create, :show, :index, :edit, :update, :destroy, :journal_books, :general_edger,
                                       :purchasing_new, :purchasing_create, :purchasing_show, :purchasing_index, :purchasing_edit, :purchasing_update, :purchasing_destroy,
                                       :cash_new, :cash_create, :cash_show, :cash_index, :cash_edit, :cash_update, :cash_destroy,
                                       :current_new, :current_create, :current_show, :current_index, :current_edit, :current_update, :current_destroy]
  
  def new
    @account = Account.new
  end

  def create
      @account = Account.new(account_params)
      sum_breakdown = (account_params[:quantity].to_f * account_params[:unit_price].to_f)
      @account.breakdown = sum_breakdown
    if @account.save
      flash[:success] = "#{l(@account.accounting_date, format: :long)}の売上帳を新規作成しました。"
      redirect_to new_account_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @account.update_attributes(account_params)
      sum_breakdown = (account_params[:quantity].to_f * account_params[:unit_price].to_f)
      @account.update_attributes(breakdown: sum_breakdown)
      flash[:success] = "#{l(@account.accounting_date, format: :long)}の売上帳情報を変更しました。"
      redirect_to accounts_url
    else
      render :edit
    end
  end

  def destroy
    @account.destroy
    flash[:success] = "#{l(@account.accounting_date, format: :long)}の売上帳のデータを一件削除しました。"
    redirect_to accounts_url
  end

  def index
    @search_params = account_search_params
    @accounts = Account.search(@search_params).where(subsidiary_journal_species: 4).merge(Account.order("accounts.accounting_date ASC")).merge(Account.order("accounts.customer DESC"))
    @next_accounts = @accounts.drop(1).push(@accounts.first)
    @before_accounts = @accounts.drop(1).unshift(@accounts.last, @accounts.first)
    
  end
  
  
  
  
  def purchasing_new
    @account = Account.new
  end

  def purchasing_create
      @account = Account.new(purchasing_account_params)
      sum_breakdown = purchasing_account_params[:quantity].to_f * purchasing_account_params[:unit_price].to_f
      @account.breakdown = sum_breakdown
    if @account.save
      flash[:success] = "#{l(@account.accounting_date, format: :long)}の仕入帳を新規作成しました。"
      redirect_to purchasing_new_accounts_url
    else
      render :purchasing_new
    end
  end

  def purchasing_edit
  end

  def purchasing_update
    if @account.update_attributes(purchasing_account_params)
      sum_breakdown = (purchasing_account_params[:quantity].to_f * purchasing_account_params[:unit_price].to_f)
      @account.update_attributes(breakdown: sum_breakdown)
      flash[:success] = "#{l(@account.accounting_date, format: :long)}の仕入帳情報を変更しました。"
      redirect_to purchasing_index_accounts_url
    else
      render :purchasing_edit
    end
  end

  def purchasing_destroy
    @account.destroy
    flash[:success] = "#{l(@account.accounting_date, format: :long)}の仕入帳データを一件削除しました。"
    redirect_to purchasing_index_accounts_url
  end

  def purchasing_index
    @search_params = purchasign_search_params
    @accounts = Account.search(@search_params).where(subsidiary_journal_species: 3).merge(Account.order("accounts.accounting_date ASC")).merge(Account.order("accounts.customer DESC"))
    @next_accounts = @accounts.drop(1).push(@accounts.first)
    @before_accounts = @accounts.drop(1).unshift(@accounts.last, @accounts.first)
  end
  
  
  
  
  
  
  
  def cash_new
    @account = Account.new
  end

  def cash_create
      @account = Account.new(cash_account_params)
    if @account.save
      flash[:success] = "#{l(@account.accounting_date, format: :long)}の現金出納帳を新規作成しました。"
      redirect_to cash_new_accounts_url
    else
      render :cash_new
    end
  end

  def cash_edit
  end

  def cash_update
    if @account.update_attributes(cash_account_params)
      flash[:success] = "#{l(@account.accounting_date, format: :long)}の現金出納帳情報を変更しました。"
      redirect_to cash_index_accounts_url
    else
      render :cash_edit
    end
  end

  def cash_destroy
    if @account.destroy
      flash[:success] = "#{l(@account.accounting_date, format: :long)}の現金出納帳のデータを一件削除しました。"
      redirect_to cash_index_accounts_url
    end
  end

  def cash_index
    @search_params = cash_search_params
    @cash_accounts = Account.cash_search(@search_params).where(subsidiary_journal_species: 1).merge(Account.order("accounts.accounting_date ASC"))
  end
  
  
  
  def current_new
    @account = Account.new
  end

  def current_create
      @account = Account.new(current_account_params)
    if @account.save
      flash[:success] = "#{l(@account.accounting_date, format: :long)}の当座預金出納帳を新規作成しました。"
      redirect_to current_new_accounts_url
    else
      render :current_new
    end
  end

  def current_edit
  end

  def current_update
    if @account.update_attributes(current_account_params)
      flash[:success] = "#{l(@account.accounting_date, format: :long)}の当座預金出納帳情報を変更しました。"
      redirect_to current_index_accounts_url(accounting_date: @first_day)
    else
      render :current_edit
    end
  end

  def current_destroy
    @account.destroy
    flash[:success] = "#{l(@account.accounting_date, format: :long)}の当座預金出納帳のデータを一件削除しました。"
    redirect_to current_index_accounts_url(accounting_date: @first_day)
  end

  def current_index
    @search_params = current_search_params
    @accounts = Account.current_search(@search_params).where(subsidiary_journal_species: 2).merge(Account.order("accounts.accounting_date ASC"))
    
    # @prev_all_month = @accounts.where(accounting_date: @first_day.prev_month.all_month)
    # @next_all_month = @accounts.where(accounting_date: @first_day.next_month.all_month)
    
    @amount_carried_forward = @accounts.select do |a|
      a.accounting_date < params[:accounting_date].to_date
    end
    
    @initial_deposit = 30000
    accounts = Account.where(subsidiary_journal_species: 2).merge(Account.order("accounts.accounting_date ASC"))
    next_accounts = accounts.drop(1).push(accounts.first)
    before_accounts = accounts.drop(1).unshift(accounts.last, accounts.first)
    
    accounts.zip(next_accounts, before_accounts) do |account, next_a, before_a|
      a_id = Account.find(account.id)
      accounts.last.balance = @initial_deposit
      balance = before_a.balance.to_i + account.deposit.to_i - account.drawer.to_i
      a_id.update_attributes(balance: balance)
    end
    
  end
  
  
  
  
  
  
  # 仕訳帳
  def journal_books
  end
  
  
  
  # 総勘定元帳
  def general_edger
  end
  
  

  private
  
  
  
  
  
    def account_params
      params.require(:account).permit(:accounting_date,
                                      :customer,
                                      :receiving_method,
                                      :product_name,
                                      :quantity,
                                      :unit_price,
                                      :subsidiary_journal_species
                                      )
    end
    
    def purchasing_account_params
      params.require(:account).permit(:accounting_date,
                                      :customer,
                                      :receiving_method,
                                      :product_name,
                                      :quantity,
                                      :unit_price,
                                      :subsidiary_journal_species
                                      )
    end
    
    def cash_account_params
      params.require(:account).permit(:accounting_date,
                                      :account_title,
                                      :description,
                                      :income,
                                      :expense,
                                      :subsidiary_journal_species
                                      )
    end
    
    def current_account_params
      params.require(:account).permit(:accounting_date,
                                      :account_title,
                                      :description,
                                      :check_number,
                                      :deposit,
                                      :drawer,
                                      :subsidiary_journal_species
                                      )
    end
    
    
    
    
    
    
    
    
    def account_search_params
      params.fetch(:search, {}).permit(:accounting_date, :customer)
    end
    
    def purchasign_search_params
      params.fetch(:search, {}).permit(:accounting_date, :customer)
    end
    
    def cash_search_params
      params.fetch(:search, {}).permit(:accounting_date, :account_title)
    end
    
    def current_search_params
      params.fetch(:search, {}).permit(:accounting_date)
    end

    # def account_params
    #   params.require(:account).permit(:accounting_date,
    #                                   :account_title,
    #                                   :description,
    #                                   :income,
    #                                   :expense,
    #                                   :deduction_balance,
    #                                   :tax_rate,
    #                                   :subsidiary_journal_species,
    #                                   :check_number,
    #                                   :deposit,
    #                                   :drawer,
    #                                   :debit_credit,
    #                                   :balance,
    #                                   :customer,
    #                                   :receiving_method,
    #                                   :product_name,
    #                                   :quantity,
    #                                   :unit_price,
    #                                   :breakdown,
    #                                   :amount,
    #                                   :general_edger_number,
    #                                   :journal_books_number,
    #                                   :notation,
    #                                   :debit_account,
    #                                   :credit_account,
    #                                   :journal_description,
    #                                   :debit_amount,
    #                                   :credit_amount,
    #                                   :journal_balance
    #                                   )
    # end

    def set_account
      @account = Account.find(params[:id])
    end

end
