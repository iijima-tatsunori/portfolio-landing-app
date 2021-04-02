class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy,
                                     :purchasing_show, :purchasing_edit, :purchasing_update, :purchasing_destroy,
                                     :cash_show, :cash_edit, :cash_update, :cash_destroy,
                                     :current_show, :current_edit, :current_update, :current_destroy]
  
  before_action :logged_in_user, only: [:transfer_slip_new, :transfer_slip_create,
                                        :new, :create, :show, :index, :edit, :update, :destroy,
                                        :purchasing_new, :purchasing_create, :purchasing_show, :purchasing_index, :purchasing_edit, :purchasing_update, :purchasing_destroy,
                                        :cash_new, :cash_create, :cash_show, :cash_index, :cash_edit, :cash_update, :cash_destroy,
                                        :current_new, :current_create, :current_show, :current_index, :current_edit, :current_update, :current_destroy,
                                        :profit_and_loss_statement, :balance_sheet]
                                        
  before_action :admin_and_accounting_user, only: [:transfer_slip_new, :transfer_slip_create,
                                                   :new, :create, :show, :index, :edit, :update, :destroy,
                                                   :purchasing_new, :purchasing_create, :purchasing_show, :purchasing_index, :purchasing_edit, :purchasing_update, :purchasing_destroy,
                                                   :cash_new, :cash_create, :cash_show, :cash_index, :cash_edit, :cash_update, :cash_destroy,
                                                   :current_new, :current_create, :current_show, :current_index, :current_edit, :current_update, :current_destroy,
                                                   :profit_and_loss_statement, :balance_sheet]
  
  before_action :set_one_month, only: [:transfer_slip_new, :transfer_slip_create,
                                       :new, :create, :show, :index, :edit, :update, :destroy,
                                       :purchasing_new, :purchasing_create, :purchasing_show, :purchasing_index, :purchasing_edit, :purchasing_update, :purchasing_destroy,
                                       :cash_new, :cash_create, :cash_show, :cash_index, :cash_edit, :cash_update, :cash_destroy,
                                       :current_new, :current_create, :current_show, :current_index, :current_edit, :current_update, :current_destroy,
                                       :journal_books, :general_ledger, :cash_general_ledger, :current_general_ledger, :payable_general_ledger, :receivable_general_ledger, :purchasing_general_ledger,
                                       :profit_and_loss_statement, :balance_sheet]
                                       
  before_action :cash_initial_deposit, only: [:create, :index, :update, :destroy, :cash_general_ledger,
                                              :purchasing_create, :purchasing_index, :purchasing_edit, :purchasing_update, :purchasing_destroy,
                                              :cash_create, :cash_index, :cash_update, :cash_destroy,
                                              :current_create, :current_index, :current_update, :current_destroy]
  before_action :current_initial_deposit, only: [:create, :index, :update, :destroy, :current_general_ledger,
                                                 :purchasing_create, :purchasing_index, :purchasing_edit, :purchasing_update, :purchasing_destroy,
                                                 :cash_create, :cash_index, :cash_update, :cash_destroy,
                                                 :current_create, :current_index, :current_update, :current_destroy]
                                                 
  before_action :select_account_title, only: [:new, :create, :edit]
  before_action :purchasing_select_account_title, only: [:purchasing_new, :purchasing_create, :purchasing_edit]
  before_action :cash_select_account_title, only: [:cash_new, :cash_create, :cash_edit]
  before_action :current_select_account_title, only: [:current_new, :current_create, :current_edit]
  
  before_action :assets_account_title, only: [:transfer_slip_new, :transfer_slip_create]
  before_action :liabilities_account_title, only: [:transfer_slip_new, :transfer_slip_create]
  before_action :cost_account_title, only: [:transfer_slip_new, :transfer_slip_create]
  before_action :revenue_account_title, only: [:transfer_slip_new, :transfer_slip_create]
  before_action :tax_rate, only: [:transfer_slip_new, :transfer_slip_create]
  
  # --------------------------売上帳------------------------------
  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if account_invalid?
      sum_breakdown = (account_params[:quantity].to_f * account_params[:unit_price].to_f)
      @account.breakdown = sum_breakdown
      if @account.save
        account_amount_algorithm
        cash_algorithm
        current_algorithm
        account_amount_sum
        flash[:success] = "#{l(@account.accounting_date, format: :long)}の売上帳を新規作成しました。"
        redirect_to new_account_url
      else
        render :new
      end
    else
      flash[:danger] = "複合仕訳欄入力エラー。"
      render :new
    end
  end
  
  def show
  end

  def edit
  end

  def update
    if account_invalid?
      sum_breakdown = (account_params[:quantity].to_f * account_params[:unit_price].to_f)
      @account.breakdown = sum_breakdown
      if @account.update_attributes(account_params)
        account_amount_algorithm
        cash_algorithm
        current_algorithm
        account_amount_sum
        flash[:success] = "#{l(@account.accounting_date, format: :long)}の売上帳情報を変更しました。"
        redirect_back(fallback_location: root_path)
      else
        flash[:danger] = "入力エラー。"
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:danger] = "複合仕訳欄入力エラー。"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @account.destroy
    account_amount_algorithm
    cash_algorithm
    current_algorithm
    account_amount_sum
    flash[:success] = "#{l(@account.accounting_date, format: :long)}の売上帳のデータを一件削除しました。"
    redirect_back(fallback_location: root_path)
  end

  def index
    @accounts = Account.where(subsidiary_journal_species: 4).merge(Account.order("accounts.accounting_date ASC")).merge(Account.order("accounts.customer DESC")).merge(Account.order("accounts.return_check_box ASC"))
    @next_accounts = @accounts.drop(1).push(@accounts.first)
    @before_accounts = @accounts.drop(1).unshift(@accounts.last, @accounts.first)
    @total_amount = 0
    @sales_returns_amount = 0
    z = 0
    @accounts.each do |account|
      if @this_month.include?(Date.parse(account[:accounting_date].to_s))
        if account.return_check_box == "0"
          @total_amount = z += account.breakdown
        end
      end
    end
    z = 0
    @accounts.each do |account|
      if @this_month.include?(Date.parse(account[:accounting_date].to_s))
        if account.return_check_box == "1"
          @sales_returns_amount = z += account.breakdown
        end
      end
    end
    if @total_amount.present? && @sales_returns_amount.present?
      @net_sales = @total_amount - @sales_returns_amount
    end
  end
  # ----------------------------------------------------------------

  # --------------------------仕入帳--------------------------------
  def purchasing_new
    @account = Account.new
  end

  def purchasing_create
    @account = Account.new(purchasing_account_params)
    if purchasing_invalid?
      sum_breakdown = (purchasing_account_params[:quantity].to_f * purchasing_account_params[:unit_price].to_f)
      @account.breakdown = sum_breakdown
      if @account.save
        purchasing_amount_algorithm
        cash_algorithm
        current_algorithm
        purchasing_amount_sum
        flash[:success] = "#{l(@account.accounting_date, format: :long)}の仕入帳を新規作成しました。"
        redirect_to purchasing_new_accounts_url
      else
        flash[:danger] = "入力エラー。"
        render :purchasing_new
      end
    else
      flash[:danger] = "複合仕訳欄入力エラー。"
      render :purchasing_new
    end
  end
  
  def purchasing_show
  end

  def purchasing_edit
  end

  def purchasing_update
    if purchasing_invalid?
      sum_breakdown = (purchasing_account_params[:quantity].to_f * purchasing_account_params[:unit_price].to_f)
      @account.breakdown = sum_breakdown
      if @account.update_attributes(purchasing_account_params)
        purchasing_amount_algorithm
        cash_algorithm
        current_algorithm
        purchasing_amount_sum
        flash[:success] = "#{l(@account.accounting_date, format: :long)}の仕入帳情報を変更しました。"
        redirect_back(fallback_location: root_path)
      else
        flash[:danger] = "入力エラー。"
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:danger] = "複合仕訳欄入力エラー。"
      redirect_back(fallback_location: root_path)
    end
  end

  def purchasing_destroy
    @account.destroy
    purchasing_amount_algorithm
    cash_algorithm
    current_algorithm
    purchasing_amount_sum
    flash[:success] = "#{l(@account.accounting_date, format: :long)}の仕入帳データを一件削除しました。"
    redirect_back(fallback_location: root_path)
  end

  def purchasing_index
    @purchasing_accounts = Account.where(subsidiary_journal_species: 3).merge(Account.order("accounts.accounting_date ASC")).merge(Account.order("accounts.customer DESC")).merge(Account.order("accounts.return_check_box ASC"))
    @purchasing_next_accounts = @purchasing_accounts.drop(1).push(@purchasing_accounts.first)
    @purchasing_before_accounts = @purchasing_accounts.drop(1).unshift(@purchasing_accounts.last, @purchasing_accounts.first)
    @total_purchase_amount = 0
    @stock_returns_amount = 0
    z = 0
    @purchasing_accounts.each do |account|
      if @this_month.include?(Date.parse(account[:accounting_date].to_s))
        if account.return_check_box == "0"
          @total_purchase_amount = z += account.breakdown
        end
      end
    end
    z = 0
    @purchasing_accounts.each do |account|
      if @this_month.include?(Date.parse(account[:accounting_date].to_s))
        if account.return_check_box == "1"
          @stock_returns_amount = z += account.breakdown
        end
      end
    end
    if @total_purchase_amount.present? && @stock_returns_amount.present?
      @net_purchase = @total_purchase_amount - @stock_returns_amount
    end
  end
  # ----------------------------------------------------------------

  # --------------------------現金出納帳----------------------------
  def cash_new
    @account = Account.new
  end

  def cash_create
     @account = Account.new(cash_account_params)
    if cash_invalid?
      if @account.save
        cash_algorithm
        flash[:success] = "#{l(@account.accounting_date, format: :long)}の現金出納帳を新規作成しました。"
        redirect_to cash_new_accounts_url
      else
        flash[:danger] = "入力エラー。"
        render :cash_new
      end
    else
      flash[:danger] = "複合仕訳欄入力エラー。"
      render :cash_new
    end
  end
  
  def cash_show
  end

  def cash_edit
  end

  def cash_update
    if cash_invalid?
      if @account.update_attributes(cash_account_params)
        cash_algorithm
        flash[:success] = "#{l(@account.accounting_date, format: :long)}の現金出納帳情報を変更しました。"
        redirect_back(fallback_location: root_path)
      else
        flash[:danger] = "入力エラー。"
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:danger] = "複合仕訳欄入力エラー。"
      redirect_back(fallback_location: root_path)
    end
  end

  def cash_destroy
    if @account.destroy
      cash_algorithm
      flash[:success] = "#{l(@account.accounting_date, format: :long)}の現金出納帳のデータを一件削除しました。"
      redirect_back(fallback_location: root_path)
    end
  end

  def cash_index
    @cash_accounts = Account.where("account_title = '現金'").or(Account.where("account_title_2 = '現金'")).or(Account.where("account_title_3 = '現金'")).or(Account.where("account_title_4 = '現金'").where("account_title_5 = '現金'")).or(Account.where(subsidiary_journal_species: 1)).merge(Account.order("accounts.accounting_date ASC"))
    
    #@accountsから、今表示されている月【@first_day】以前のデータを全て取得
    @amount_carried_forward = @cash_accounts.select do |c_a|
      c_a.accounting_date < @first_day
    end
    @this_month_last_balance = @cash_accounts.select do |c_a|
      c_a.accounting_date <= @last_day
    end
  end
  # -----------------------------------------------------------------
  
  # --------------------------預金出納帳-------------------------
  def current_new
    @account = Account.new
  end

  def current_create
    @account = Account.new(current_account_params)
    if current_invalid?
      if @account.save
        current_algorithm
        flash[:success] = "#{l(@account.accounting_date, format: :long)}の預金出納帳を新規作成しました。"
        redirect_to current_new_accounts_url
      else
        flash[:danger] = "入力エラー。"
        render :current_new
      end
    else
      flash[:danger] = "複合仕訳欄入力エラー。"
      render :current_new
    end
  end
  
  def current_show
  end

  def current_edit
  end

  def current_update
    if current_invalid?
      if @account.update_attributes(current_account_params)
        current_algorithm
        flash[:success] = "#{l(@account.accounting_date, format: :long)}の預金出納帳情報を変更しました。"
        redirect_back(fallback_location: root_path)
      else
        flash[:danger] = "入力エラー。"
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:danger] = "複合仕訳欄入力エラー。"
      redirect_back(fallback_location: root_path)
    end
  end

  def current_destroy
    @account.destroy
    current_algorithm
    flash[:success] = "#{l(@account.accounting_date, format: :long)}の預金出納帳のデータを一件削除しました。"
    redirect_back(fallback_location: root_path)
  end

  def current_index
    @current_accounts = Account.where("account_title = '預金'").or(Account.where("account_title_2 = '預金'")).or(Account.where("account_title_3 = '預金'")).or(Account.where("account_title_4 = '預金'").where("account_title_5 = '預金'")).or(Account.where(subsidiary_journal_species: 2)).merge(Account.order("accounts.accounting_date ASC"))
    
    #@accountsから、今表示されている月【@first_day】以前のデータを全て取得
    @amount_carried_forward = @current_accounts.select do |c_a|
      c_a.accounting_date < @first_day
    end
    @this_month_last_balance = @current_accounts.select do |c_a|
      c_a.accounting_date <= @last_day
    end
  end
  # ----------------------------------------------------------------
  
  # --------------------------振替伝票作成------------------------------
  def transfer_slip_new
    @transfer_account = Account.new
    @transfer_account.compound_journals.build
  end

  def transfer_slip_create
    @transfer_account = Account.new(transfer_slip_account_params)
    if @transfer_account.save
      @transfer_account = Account.new(transfer_slip_account_params)
      flash[:success] = "#{l(@transfer_account.accounting_date, format: :long)}新規作成しました。"
      redirect_to transfer_slip_new_accounts_url
    else
      @transfer_account = Account.new(transfer_slip_account_params)
      render :transfer_slip_new
    end
  end
  # --------------------------------------------------------------
  
  # --------------------------仕訳帳--------------------------------
  def journal_books
    @journal_accounts = Account.all.merge(Account.order("accounts.accounting_date ASC")).merge(Account.order("accounts.subsidiary_journal_species ASC"))
  end
  # ----------------------------------------------------------------
  
  # --------------------------総勘定元帳----------------------------
  def general_ledger
    @general_ledger_accounts = Account.where(subsidiary_journal_species: 4).merge(Account.order("accounts.accounting_date ASC"))
    @amount_carried_forward = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date < @first_day
    end
    @this_month_last_balance = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date <= @last_day
    end
    account_balance_sum
  end
  
  def purchasing_general_ledger
    @general_ledger_accounts = Account.where(subsidiary_journal_species: 3).merge(Account.order("accounts.accounting_date ASC"))
    @amount_carried_forward = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date < @first_day
    end
    @this_month_last_balance = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date <= @last_day
    end
    purchasing_balance_sum
  end
  
  def cash_general_ledger
    @general_ledger_accounts = Account.where("account_title = '現金'").or(Account.where("account_title_2 = '現金'")).or(Account.where("account_title_3 = '現金'")).or(Account.where("account_title_4 = '現金'").where("account_title_5 = '現金'")).or(Account.where(subsidiary_journal_species: 1)).merge(Account.order("accounts.accounting_date ASC"))
    @amount_carried_forward = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date < @first_day
    end
    @this_month_last_balance = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date <= @last_day
    end
    cash_balance_sum
  end
  
  def current_general_ledger
    @general_ledger_accounts = Account.where("account_title = '預金'").or(Account.where("account_title_2 = '預金'")).or(Account.where("account_title_3 = '預金'")).or(Account.where("account_title_4 = '預金'").where("account_title_5 = '預金'")).or(Account.where(subsidiary_journal_species: 2)).merge(Account.order("accounts.accounting_date ASC"))
    @amount_carried_forward = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date < @first_day
    end
    @this_month_last_balance = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date <= @last_day
    end
    current_balance_sum
  end
  
  def payable_general_ledger
    @general_ledger_accounts = Account.where("account_title = '買掛金'").or(Account.where("account_title_2 = '買掛金'")).or(Account.where("account_title_3 = '買掛金'")).or(Account.where("account_title_4 = '買掛金'").where("account_title_5 = '買掛金'")).merge(Account.order("accounts.accounting_date ASC"))
    @amount_carried_forward = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date < @first_day
    end
    @this_month_last_balance = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date <= @last_day
    end
    payable_balance_sum
  end
  
  def receivable_general_ledger
    @general_ledger_accounts = Account.where("account_title = '売掛金'").or(Account.where("account_title_2 = '売掛金'")).or(Account.where("account_title_3 = '売掛金'")).or(Account.where("account_title_4 = '売掛金'").where("account_title_5 = '売掛金'")).merge(Account.order("accounts.accounting_date ASC"))
    @amount_carried_forward = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date < @first_day
    end
    @this_month_last_balance = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date <= @last_day
    end
    receivable_balance_sum
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
    # ------------------------before_action-------------------------
    def set_account
      @account = Account.find(params[:id])
    end
    # 初期現金残高
    def cash_initial_deposit
      @cash_initial_deposit = 2000
    end
    # 初期預金残高
    def current_initial_deposit
      @current_initial_deposit = 1000
    end
    
    # 売上帳勘定科目用(account_titleのselect_box選択用)--view(new, create, edit)
    def select_account_title
      @select_account_title = ["現金",
                               "預金",
                               "買掛金",
                               "売掛金",
                               "当座預金",
                               "給料",
                               "交際費",
                               "消耗品費",
                               "車両費",
                               "材料費",
                               "修繕費",
                               "水道光熱費",
                               "通信費",
                               "旅費交通費",
                               "荷造運賃",
                               "借入金",
                               "家賃",
                               "租税公課",
                               "支払利息",
                               "固定資産除却損",
                               "受取利息",
                               "雑収入",
                               "固定資産売却益",
                               "受取手形",
                               "支払手形",
                               "商品",
                               "建物",
                               "機械装置",
                               "車両運搬具",
                               "土地",
                               "未払消費税",
                               "未払法人税等",
                               "未払費用",
                               "長期借入金",
                               "社債",
                               "退職給付引当金",
                               "その他有価証券",
                               "関連会社株式"]
    end
    # -----------------------------------------
    
    # 仕入帳勘定科目用(account_titleのselect_box選択用)--view(purchasing_new, purchasing_create, purchasing_edit)
    def purchasing_select_account_title
      @purchasing_select_account_title = ["現金",
                                         "預金",
                                         "買掛金",
                                         "売掛金",
                                         "当座預金",
                                         "給料",
                                         "交際費",
                                         "消耗品費",
                                         "車両費",
                                         "材料費",
                                         "修繕費",
                                         "水道光熱費",
                                         "通信費",
                                         "旅費交通費",
                                         "荷造運賃",
                                         "借入金",
                                         "家賃",
                                         "租税公課",
                                         "支払利息",
                                         "固定資産除却損",
                                         "受取利息",
                                         "雑収入",
                                         "固定資産売却益",
                                         "受取手形",
                                         "支払手形",
                                         "商品",
                                         "建物",
                                         "機械装置",
                                         "車両運搬具",
                                         "土地",
                                         "未払消費税",
                                         "未払法人税等",
                                         "未払費用",
                                         "長期借入金",
                                         "社債",
                                         "退職給付引当金",
                                         "その他有価証券",
                                         "関連会社株式"]
    end
    # -----------------------------------------
    
    # 現金出納帳勘定科目用(account_titleのselect_box選択用)--view(cash_new, cash_create, cash_edit)
    def cash_select_account_title
      @cash_select_account_title = ["買掛金",
                                   "売掛金",
                                   "給料",
                                   "交際費",
                                   "消耗品費",
                                   "車両費",
                                   "材料費",
                                   "修繕費",
                                   "水道光熱費",
                                   "通信費",
                                   "旅費交通費",
                                   "荷造運賃",
                                   "借入金",
                                   "家賃",
                                   "租税公課",
                                   "支払利息",
                                   "固定資産除却損",
                                   "受取利息",
                                   "雑収入",
                                   "固定資産売却益",
                                   "受取手形",
                                   "支払手形",
                                   "商品",
                                   "建物",
                                   "機械装置",
                                   "車両運搬具",
                                   "土地",
                                   "未払消費税",
                                   "未払法人税等",
                                   "未払費用",
                                   "長期借入金",
                                   "社債",
                                   "退職給付引当金",
                                   "その他有価証券",
                                   "関連会社株式"]
    end
    # -----------------------------------------
    
    # 預金出納帳勘定科目用(account_titleのselect_box選択用)--view(current_new, current_create, current_edit)
    def current_select_account_title
      @current_select_account_title = ["買掛金",
                                       "売掛金",
                                       "給料",
                                       "交際費",
                                       "消耗品費",
                                       "車両費",
                                       "材料費",
                                       "修繕費",
                                       "水道光熱費",
                                       "通信費",
                                       "旅費交通費",
                                       "荷造運賃",
                                       "借入金",
                                       "家賃",
                                       "租税公課",
                                       "支払利息",
                                       "固定資産除却損",
                                       "受取利息",
                                       "雑収入",
                                       "固定資産売却益",
                                       "受取手形",
                                       "支払手形",
                                       "商品",
                                       "建物",
                                       "機械装置",
                                       "車両運搬具",
                                       "土地",
                                       "未払消費税",
                                       "未払法人税等",
                                       "未払費用",
                                       "長期借入金",
                                       "社債",
                                       "退職給付引当金",
                                       "その他有価証券",
                                       "関連会社株式"]
    end
    # -----------------------------------------
    
    # 資産勘定科目用(のselect_box選択用)--view()
    def assets_account_title
      @assets_account_title = %w[現金
                                普通預金
                                普通預金2
                                売掛金
                                当座預金
                                定期預金
                                郵便貯金
                                受取手形
                                売掛金
                                商品
                                製品
                                原材料
                                仕掛品
                                前渡金
                                前払費用
                                立替金
                                仮払金
                                未収入金
                                短期貸付金
                                建物
                                機械装置
                                車両運搬具
                                工具器具備品
                                一括償却資産
                                減価償却累計額
                                土地
                                電話加入権
                                ソフトウェア
                                敷金
                                差入保証金
                                長期貸付金
                                創立費
                                開業費
                                ]
    end
    # -----------------------------------------
    
    # 負債/純資産勘定科目用(のselect_box選択用)--view()
    def liabilities_account_title
      @liabilities_account_title = %w[買掛金
                                    支払手形
                                    短期借入金
                                    未払金
                                    未払費用
                                    前受金
                                    預り金
                                    源泉税等預り金
                                    仮受金
                                    賞与引当金
                                    役員賞与引当金
                                    未払法人税等
                                    未払事業税等
                                    未払消費税等
                                    長期借入金
                                    --純資産--
                                    資本金
                                    資本準備金
                                    利益準備金
                                    別途積立金
                                    繰越利益剰余金
                                    ]
    end
    # -----------------------------------------
    
    # 費用勘定科目用(のselect_box選択用)--view()
    def cost_account_title
      @cost_account_title = %w[売上値引高
                              外注加工費
                              期首商品棚卸高
                              期首製品棚卸高
                              仕入高
                              支払利息
                              雑損失
                              前期利益修正損
                              固定資産売却損
                              法人税･住民税及び事業税
                              給料手当
                              役員報酬
                              役員賞与
                              雑給
                              賞与
                              退職金
                              法定福利費
                              福利厚生費
                              採用教育費
                              通信費
                              荷造運賃
                              水道光熱費
                              旅費交通費
                              広告宣伝費
                              販売手数料
                              交際費
                              少額交際費
                              会議費
                              消耗品費
                              事務用品費
                              備品消耗品
                              新聞図書費
                              修繕費
                              地代家賃
                              車両費
                              保険料
                              租税公課
                              諸会費
                              賃借料
                              支払手数料
                              減価償却費
                              研究開発費
                              寄附金
                              雑費
                              ]
    end
    # -----------------------------------------
    
    # 収益勘定科目用(のselect_box選択用)--view()
    def revenue_account_title
      @revenue_account_title = %w[売上高
                                仕入値引高
                                期末商品棚卸高
                                受取利息
                                雑収入
                                営業外利益
                                前期利益修正益
                                固定資産売却益
                                特別利益
                                ]
    end
    # -----------------------------------------
    
    # 税率用(のselect_box選択用)--view()
    def tax_rate
      @tax_rate = %w[対象外
                     8%
                     10%
                    ]
    end
    # -----------------------------------------
    # ----------------------------------------------------------------
    
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
                                      :_destroy
                                      ])
    end
    
    def account_params
      params.require(:account).permit(:accounting_date,
                                      :customer,
                                      :account_title,
                                      :individual_amount,
                                      :account_title_2,
                                      :individual_amount_2,
                                      :account_title_3,
                                      :individual_amount_3,
                                      :account_title_4,
                                      :individual_amount_4,
                                      :account_title_5,
                                      :individual_amount_5,
                                      :product_name,
                                      :quantity,
                                      :unit_price,
                                      :subsidiary_journal_species,
                                      :return_check_box
                                      )
    end
    
    def purchasing_account_params
      params.require(:account).permit(:accounting_date,
                                      :customer,
                                      :account_title,
                                      :account_title_2,
                                      :account_title_3,
                                      :account_title_4,
                                      :account_title_5,
                                      :individual_amount,
                                      :individual_amount_2,
                                      :individual_amount_3,
                                      :individual_amount_4,
                                      :individual_amount_5,
                                      :product_name,
                                      :quantity,
                                      :unit_price,
                                      :subsidiary_journal_species,
                                      :return_check_box
                                      )
    end
    
    def cash_account_params
      params.require(:account).permit(:accounting_date,
                                      :account_title,
                                      :account_title_2,
                                      :account_title_3,
                                      :account_title_4,
                                      :account_title_5,
                                      :individual_amount,
                                      :individual_amount_2,
                                      :individual_amount_3,
                                      :individual_amount_4,
                                      :individual_amount_5,
                                      :description,
                                      :income,
                                      :expense,
                                      :subsidiary_journal_species
                                      )
    end
    
    def current_account_params
      params.require(:account).permit(:accounting_date,
                                      :account_title,
                                      :account_title_2,
                                      :account_title_3,
                                      :account_title_4,
                                      :account_title_5,
                                      :individual_amount,
                                      :individual_amount_2,
                                      :individual_amount_3,
                                      :individual_amount_4,
                                      :individual_amount_5,
                                      :description,
                                      :deposit,
                                      :drawer,
                                      :subsidiary_journal_species
                                      )
    end
    # --------------------------------------------------------------

end
