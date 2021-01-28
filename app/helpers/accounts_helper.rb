module AccountsHelper
  
  # 売上帳合計(amount)用計算処理---コントローラー(create,update,destroy)
  def account_amount_algorithm
    @accounts = Account.where(subsidiary_journal_species: 4).merge(Account.order("accounts.accounting_date ASC")).merge(Account.order("accounts.customer DESC")).merge(Account.order("accounts.return_check_box ASC"))
    @next_accounts = @accounts.drop(1).push(@accounts.first)
    @before_accounts = @accounts.drop(1).unshift(@accounts.last, @accounts.first)
    zero = 0
    @accounts.zip(@next_accounts, @before_accounts) do |account, next_a, before_a|
    zero = 0 if account.accounting_date != before_a.accounting_date || account.customer != before_a.customer || account.return_check_box == "1" && before_a.return_check_box == "0"
      if account.accounting_date == next_a.accounting_date && account.customer == next_a.customer || account.accounting_date == before_a.accounting_date && account.customer == before_a.customer
        amount = zero += account.breakdown
      else
        zero = 0
        amount = zero += account.breakdown
      end
      a_id = Account.find(account.id)
      if account.accounting_date != next_a.accounting_date || account.customer != next_a.customer || account.return_check_box == "0" && next_a.return_check_box == "1"
        a_id.update_attributes(amount: amount)
      else
        a_id.update_attributes(amount: nil)
      end
    end
  end
  # -----------------------------------------
  
  # 仕入帳合計(amount)用計算処理---コントローラー(purchasing_create, purchasing_update, purchasing_destroy)
  def purchasing_amount_algorithm
    @purchasing_accounts = Account.where(subsidiary_journal_species: 3).merge(Account.order("accounts.accounting_date ASC")).merge(Account.order("accounts.customer DESC")).merge(Account.order("accounts.return_check_box ASC"))
    @next_accounts = @purchasing_accounts.drop(1).push(@purchasing_accounts.first)
    @before_accounts = @purchasing_accounts.drop(1).unshift(@purchasing_accounts.last, @purchasing_accounts.first)
    zero = 0
    @purchasing_accounts.zip(@next_accounts, @before_accounts) do |account, next_a, before_a|
    zero = 0 if account.accounting_date != before_a.accounting_date || account.customer != before_a.customer || account.return_check_box == "1" && before_a.return_check_box == "0"
      if account.accounting_date == next_a.accounting_date && account.customer == next_a.customer || account.accounting_date == before_a.accounting_date && account.customer == before_a.customer
        amount = zero += account.breakdown
      else
        zero = 0
        amount = zero += account.breakdown
      end
      a_id = Account.find(account.id)
      if account.accounting_date != next_a.accounting_date || account.customer != next_a.customer || account.return_check_box == "0" && next_a.return_check_box == "1"
        a_id.update_attributes(amount: amount)
      else
        a_id.update_attributes(amount: nil)
      end
    end
  end
  # -----------------------------------------
  
  # 現金出納帳用計算処理---コントローラー(cash_update, cash_destroy, cash_create)
  def cash_algorithm
    @cash_accounts = Account.where(subsidiary_journal_species: 1).merge(Account.order("accounts.accounting_date ASC"))
    @cash_accounts.each do |account|
      if @cash_accounts[0] == account
        balance = @cash_initial_deposit + account.income.to_i - account.expense.to_i
      else
        balance = @balance.to_i + account.income.to_i - account.expense.to_i
      end
      a_id = Account.find(account.id)
      a_id.update_attributes(balance: balance)
      @balance = balance
    end
  end
  # -----------------------------------------
  
  # 当座預金出納帳用計算処理---コントローラー(current_update, current_destroy, current_create)
  def current_algorithm
    @current_accounts = Account.where(subsidiary_journal_species: 2).merge(Account.order("accounts.accounting_date ASC"))
    @current_accounts.each do |account|
      if @current_accounts[0] == account
        balance = @current_initial_deposit + account.deposit.to_i - account.drawer.to_i
      else
        balance = @balance.to_i + account.deposit.to_i - account.drawer.to_i
      end
      a_id = Account.find(account.id)
      a_id.update_attributes(balance: balance)
      @balance = balance
    end
  end
  # -----------------------------------------
  
  # 仕訳帳用(補助簿種類名切替)---view(journal_books)
  def journal_species(species)
    case species
    when 1 then
      "現金出納帳"
    when 2 then
      "当座預金出納帳"
    when 3 then
      "仕入帳"
    when 4 then
      "売上帳"
    else
      ""
    end
  end
  # -----------------------------------------
  
  # 仕訳帳用(補助簿編集モーダル表示リンク切替)---view(journal_books)
  def edit_link(account, species)
    case species
    when 1 then
      cash_edit_account_url(account)
    when 2 then
      current_edit_account_path(account)
    when 3 then
      purchasing_edit_account_path(account)
    when 4 then
      edit_account_path(account)
    else
      root_path
    end
  end
  # -----------------------------------------
  
  # 仕訳帳用(補助簿詳細画面遷移リンク切替)---view(journal_books)
  def show_link(account, species)
    case species
    when 1 then
      cash_show_account_url(account)
    when 2 then
      current_show_account_path(account)
    when 3 then
      purchasing_show_account_path(account)
    when 4 then
      account_path(account)
    else
      root_path
    end
  end
  # -----------------------------------------
  
  # 仕訳帳用(補助簿種類名切替)---view(journal_books)
  def journal_btn(species)
    case species
    when 1 then
      "btn btn-success"
    when 2 then
      "btn btn-info"
    when 3 then
      "btn btn-warning"
    when 4 then
      "btn btn-danger"
    else
      "btn btn-light"
    end
  end
  # -----------------------------------------
  
  # 売上帳(複合仕訳が、account_paramsの各individual_amountの合計値が収入か支出と合っているか判定)--controller(create, update)
  def account_invalid?
    account = true
    unless account_params[:individual_amount].blank? && account_params[:individual_amount_2].blank? && account_params[:individual_amount_3].blank? && account_params[:individual_amount_4].blank? && account_params[:individual_amount_5].blank?
      if account_params[:individual_amount].to_f + account_params[:individual_amount_2].to_f + account_params[:individual_amount_3].to_f + account_params[:individual_amount_4].to_f + account_params[:individual_amount_5].to_f == account_params[:quantity].to_f * account_params[:unit_price].to_f && account_params[:individual_amount].present?
        account = true
      else
        account = false
      end
    end
    account
  end
  # -----------------------------------------
  
  # 仕入帳(複合仕訳が、purchasing_account_paramsの各individual_amountの合計値が収入か支出と合っているか判定)--controller(purchasing_create, purchasing_update)
  def purchasing_invalid?
    purchasing = true
    unless purchasing_account_params[:individual_amount].blank? && purchasing_account_params[:individual_amount_2].blank? && purchasing_account_params[:individual_amount_3].blank? && purchasing_account_params[:individual_amount_4].blank? && purchasing_account_params[:individual_amount_5].blank?
      if purchasing_account_params[:individual_amount].to_f + purchasing_account_params[:individual_amount_2].to_f + purchasing_account_params[:individual_amount_3].to_f + purchasing_account_params[:individual_amount_4].to_f + purchasing_account_params[:individual_amount_5].to_f == purchasing_account_params[:quantity].to_f * purchasing_account_params[:unit_price].to_f && purchasing_account_params[:individual_amount].present?
        purchasing = true
      else
        purchasing = false
      end
    end
    purchasing
  end
  # -----------------------------------------
  
  # 現金出納帳用(複合仕訳が、cash_account_paramsの各individual_amountの合計値が収入か支出と合っているか判定)--controller(cash_create, cash_update)
  def cash_invalid?
    cash = true
    unless cash_account_params[:individual_amount].blank? && cash_account_params[:individual_amount_2].blank? && cash_account_params[:individual_amount_3].blank? && cash_account_params[:individual_amount_4].blank? && cash_account_params[:individual_amount_5].blank?
      if cash_account_params[:individual_amount].to_f + cash_account_params[:individual_amount_2].to_f + cash_account_params[:individual_amount_3].to_f + cash_account_params[:individual_amount_4].to_f + cash_account_params[:individual_amount_5].to_f == cash_account_params[:income].to_f + cash_account_params[:expense].to_f && cash_account_params[:individual_amount].present?
        cash = true
      else
        cash = false
      end
    end
    cash
  end
  # -----------------------------------------
  
  # 当座預金出納帳用(複合仕訳が、current_account_paramsの各individual_amountの合計値が収入か支出と合っているか判定)--controller(current_create, current_update)
  def current_invalid?
    current = true
    unless current_account_params[:individual_amount].blank? && current_account_params[:individual_amount_2].blank? && current_account_params[:individual_amount_3].blank? && current_account_params[:individual_amount_4].blank? && current_account_params[:individual_amount_5].blank?
      if current_account_params[:individual_amount].to_f + current_account_params[:individual_amount_2].to_f + current_account_params[:individual_amount_3].to_f + current_account_params[:individual_amount_4].to_f + current_account_params[:individual_amount_5].to_f == current_account_params[:deposit].to_f + current_account_params[:drawer].to_f && current_account_params[:individual_amount].present?
        current = true
      else
        current = false
      end
    end
    current
  end
  # -----------------------------------------
end
