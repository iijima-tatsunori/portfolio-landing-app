module AccountsHelper
  
  def tax_rates(tax)
    case tax
    when 0 then
      "対象外"
    when 1 then
      "8%"
    when 2 then
      "10%"
    else
      ""
    end
  end
  
  # 総勘定元帳一覧用(勘定科目)---view()
  def compound_journals_arys
    arys = Array.new
    compound_journals = CompoundJournal.all
      compound_journals.each do |compound_journal|
        arys.push(compound_journal.account_title, compound_journal.right_account_title)
      end
    arys
  end
  
  def compound_journals_ary
    compound_journals_arys.compact.delete_if(&:empty?).uniq
  end
  
  def left_amount(ary)
    zero = 0
    lam = 0
    account_titles = CompoundJournal.where(account_title: ary)
    account_titles.each do |bb|
      lam = zero += bb.amount.to_i
    end
    lam.to_i
  end
  
  def right_amount(ary)
    zero = 0
    ram = 0
    account_titles = CompoundJournal.where(right_account_title: ary)
    account_titles.each do |bb|
      ram = zero += bb.right_amount.to_i
    end
    ram.to_i
  end
  # -----------------------------------------
  
  # 総勘定元帳一覧用(補助科目)---view()
  def sub_compound_journals_arys
    arys = Array.new
    compound_journals = CompoundJournal.all
      compound_journals.each do |compound_journal|
        arys.push(compound_journal.sub_account_title, compound_journal.right_sub_account_title)
      end
    arys
  end
  
  def sub_compound_journals_ary
    sub_compound_journals_arys.compact.delete_if(&:empty?).uniq
  end
  
  def sub_left_amount(ary)
    zero = 0
    lam = 0
    account_titles = CompoundJournal.where(sub_account_title: ary)
    account_titles.each do |bb|
      lam = zero += bb.amount.to_i
    end
    lam.to_i
  end
  
  def sub_right_amount(ary)
    zero = 0
    ram = 0
    account_titles = CompoundJournal.where(right_sub_account_title: ary)
    account_titles.each do |bb|
      ram = zero += bb.right_amount.to_i
    end
    ram.to_i
  end
  # -----------------------------------------
  
  # 仕訳帳用(補助簿種類名切替)---view(journal_books)
  def journal_species(species)
    case species
    when 1 then
      "現金出納帳"
    when 2 then
      "預金出納帳"
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
      ""
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
  
  # 売上帳合計(amount)用計算処理---コントローラー(create, update, destroy)
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
    @cash_accounts = Account.where("account_title = '現金'").or(Account.where("account_title_2 = '現金'")).or(Account.where("account_title_3 = '現金'")).or(Account.where("account_title_4 = '現金'").where("account_title_5 = '現金'")).or(Account.where(subsidiary_journal_species: 1)).merge(Account.order("accounts.accounting_date ASC"))
    @cash_accounts.each do |account|
      if account.subsidiary_journal_species == 1
        if @cash_accounts[0] == account
          if @cash_initial_deposit < 0
            balance = @cash_initial_deposit - account.income.to_i - account.expense.to_i
          else
            balance = @cash_initial_deposit + account.income.to_i - account.expense.to_i
          end
        else
          balance = @balance + account.income.to_i - account.expense.to_i
        end
      elsif account.subsidiary_journal_species == 4
        if @cash_accounts[0] == account
          if account.return_check_box == "0"
            if account.account_title == "現金"
              if account.individual_amount.present?
                balance = @cash_initial_deposit + account.individual_amount
              else
                balance = @cash_initial_deposit + account.breakdown
              end
            elsif account.account_title_2 == "現金"
              balance = @cash_initial_deposit + account.individual_amount_2
            elsif account.account_title_3 == "現金"
              balance = @cash_initial_deposit + account.individual_amount_3
            elsif account.account_title_4 == "現金"
              balance = @cash_initial_deposit + account.individual_amount_4
            elsif account.account_title_5 == "現金"
              balance = @cash_initial_deposit + account.individual_amount_5
            end
          elsif account.return_check_box == "1"
            if account.account_title == "現金"
              if account.individual_amount.present?
                balance = @cash_initial_deposit - account.individual_amount
              else
                balance = @cash_initial_deposit - account.breakdown
              end
            elsif account.account_title_2 == "現金"
              balance = @cash_initial_deposit - account.individual_amount_2
            elsif account.account_title_3 == "現金"
              balance = @cash_initial_deposit - account.individual_amount_3
            elsif account.account_title_4 == "現金"
              balance = @cash_initial_deposit - account.individual_amount_4
            elsif account.account_title_5 == "現金"
              balance = @cash_initial_deposit - account.individual_amount_5
            end
          else
          end
        else
          if account.return_check_box == "0"
            if account.account_title == "現金"
              if account.individual_amount.present?
                balance = @balance + account.individual_amount
              else
                balance = @balance + account.breakdown
              end
            elsif account.account_title_2 == "現金"
              balance = @balance + account.individual_amount_2
            elsif account.account_title_3 == "現金"
              balance = @balance + account.individual_amount_3
            elsif account.account_title_4 == "現金"
              balance = @balance + account.individual_amount_4
            elsif account.account_title_5 == "現金"
              balance = @balance + account.individual_amount_5
            end
          elsif account.return_check_box == "1"
            if account.account_title == "現金"
              if account.individual_amount.present?
                balance = @balance - account.individual_amount
              else
                balance = @balance - account.breakdown
              end
            elsif account.account_title_2 == "現金"
              balance = @balance - account.individual_amount_2
            elsif account.account_title_3 == "現金"
              balance = @balance - account.individual_amount_3
            elsif account.account_title_4 == "現金"
              balance = @balance - account.individual_amount_4
            elsif account.account_title_5 == "現金"
              balance = @balance - account.individual_amount_5
            end
          else
          end
        end
      elsif account.subsidiary_journal_species == 3
        if @cash_accounts[0] == account
          if account.return_check_box == "1"
            if account.account_title == "現金"
              if account.individual_amount.present?
                balance = @cash_initial_deposit + account.individual_amount
              else
                balance = @cash_initial_deposit + account.breakdown
              end
            elsif account.account_title_2 == "現金"
              balance = @cash_initial_deposit + account.individual_amount_2
            elsif account.account_title_3 == "現金"
              balance = @cash_initial_deposit + account.individual_amount_3
            elsif account.account_title_4 == "現金"
              balance = @cash_initial_deposit + account.individual_amount_4
            elsif account.account_title_5 == "現金"
              balance = @cash_initial_deposit + account.individual_amount_5
            end
          elsif account.return_check_box == "0"
            if account.account_title == "現金"
              if account.individual_amount.present?
                balance = @cash_initial_deposit - account.individual_amount
              else
                balance = @cash_initial_deposit - account.breakdown
              end
            elsif account.account_title_2 == "現金"
              balance = @cash_initial_deposit - account.individual_amount_2
            elsif account.account_title_3 == "現金"
              balance = @cash_initial_deposit - account.individual_amount_3
            elsif account.account_title_4 == "現金"
              balance = @cash_initial_deposit - account.individual_amount_4
            elsif account.account_title_5 == "現金"
              balance = @cash_initial_deposit - account.individual_amount_5
            end
          else 
          end
        else
          if account.return_check_box == "1"
            if account.account_title == "現金"
              if account.individual_amount.present?
                balance = @balance + account.individual_amount
              else
                balance = @balance + account.breakdown
              end
            elsif account.account_title_2 == "現金"
              balance = @balance + account.individual_amount_2
            elsif account.account_title_3 == "現金"
              balance = @balance + account.individual_amount_3
            elsif account.account_title_4 == "現金"
              balance = @balance + account.individual_amount_4
            elsif account.account_title_5 == "現金"
              balance = @balance + account.individual_amount_5
            end
          elsif account.return_check_box == "0"
            if account.account_title == "現金"
              if account.individual_amount.present?
                balance = @balance - account.individual_amount
              else
                balance = @balance - account.breakdown
              end
            elsif account.account_title_2 == "現金"
              balance = @balance - account.individual_amount_2
            elsif account.account_title_3 == "現金"
              balance = @balance - account.individual_amount_3
            elsif account.account_title_4 == "現金"
              balance = @balance - account.individual_amount_4
            elsif account.account_title_5 == "現金"
              balance = @balance - account.individual_amount_5
            end
          else
          end
        end
      end
      a_id = Account.find(account.id)
      a_id.update_attributes(balance: balance)
      @balance = balance.to_i
    end
  end
  # -----------------------------------------
  
  # 預金出納帳用計算処理---コントローラー(current_update, current_destroy, current_create)
  def current_algorithm
    @current_accounts = Account.where("account_title = '預金'").or(Account.where("account_title_2 = '預金'")).or(Account.where("account_title_3 = '預金'")).or(Account.where("account_title_4 = '預金'").where("account_title_5 = '預金'")).or(Account.where(subsidiary_journal_species: 2)).merge(Account.order("accounts.accounting_date ASC"))
    @current_accounts.each do |account|
      if account.subsidiary_journal_species == 2
        if @current_accounts[0] == account
          if @cash_initial_deposit < 0
            balance = @current_initial_deposit - account.deposit.to_i - account.drawer.to_i
          else
            balance = @current_initial_deposit + account.deposit.to_i - account.drawer.to_i
          end
        else
          balance = @balance.to_i + account.deposit.to_i - account.drawer.to_i
        end
      elsif account.subsidiary_journal_species == 4
        if @current_accounts[0] == account
          if account.return_check_box == "0"
            if account.account_title == "預金"
              if account.individual_amount.present?
                balance = @current_initial_deposit + account.individual_amount
              else
                balance = @current_initial_deposit + account.breakdown
              end
            elsif account.account_title_2 == "預金"
              balance = @current_initial_deposit + account.individual_amount_2
            elsif account.account_title_3 == "預金"
              balance = @current_initial_deposit + account.individual_amount_3
            elsif account.account_title_4 == "預金"
              balance = @current_initial_deposit + account.individual_amount_4
            elsif account.account_title_5 == "預金"
              balance = @current_initial_deposit + account.individual_amount_5
            end
          elsif account.return_check_box == "1"
            if account.account_title == "預金"
              if account.individual_amount.present?
                balance = @current_initial_deposit - account.individual_amount
              else
                balance = @current_initial_deposit - account.breakdown
              end
            elsif account.account_title_2 == "預金"
              balance = @current_initial_deposit - account.individual_amount_2
            elsif account.account_title_3 == "預金"
              balance = @current_initial_deposit - account.individual_amount_3
            elsif account.account_title_4 == "預金"
              balance = @current_initial_deposit - account.individual_amount_4
            elsif account.account_title_5 == "預金"
              balance = @current_initial_deposit - account.individual_amount_5
            end
          else 
          end
        else
          if account.return_check_box == "0"
            if account.account_title == "預金"
              if account.individual_amount.present?
                balance = @balance + account.individual_amount
              else
                balance = @balance + account.breakdown
              end
            elsif account.account_title_2 == "預金"
              balance = @balance + account.individual_amount_2
            elsif account.account_title_3 == "預金"
              balance = @balance + account.individual_amount_3
            elsif account.account_title_4 == "預金"
              balance = @balance + account.individual_amount_4
            elsif account.account_title_5 == "預金"
              balance = @balance + account.individual_amount_5
            end
          elsif account.return_check_box == "1"
            if account.account_title == "預金"
              if account.individual_amount.present?
                balance = @balance - account.individual_amount
              else
                balance = @balance - account.breakdown
              end
            elsif account.account_title_2 == "預金"
              balance = @balance - account.individual_amount_2
            elsif account.account_title_3 == "預金"
              balance = @balance - account.individual_amount_3
            elsif account.account_title_4 == "預金"
              balance = @balance - account.individual_amount_4
            elsif account.account_title_5 == "預金"
              balance = @balance - account.individual_amount_5
            end
          else
          end
        end
      elsif account.subsidiary_journal_species == 3
        if @current_accounts[0] == account
          if account.return_check_box == "1"
            if account.account_title == "預金"
              if account.individual_amount.present?
                balance = @current_initial_deposit + account.individual_amount
              else
                balance = @current_initial_deposit + account.breakdown
              end
            elsif account.account_title_2 == "預金"
              balance = @current_initial_deposit + account.individual_amount_2
            elsif account.account_title_3 == "預金"
              balance = @current_initial_deposit + account.individual_amount_3
            elsif account.account_title_4 == "預金"
              balance = @current_initial_deposit + account.individual_amount_4
            elsif account.account_title_5 == "預金"
              balance = @current_initial_deposit + account.individual_amount_5
            end
          elsif account.return_check_box == "0"
            if account.account_title == "預金"
              if account.individual_amount.present?
                balance = @current_initial_deposit - account.individual_amount
              else
                balance = @current_initial_deposit - account.breakdown
              end
            elsif account.account_title_2 == "預金"
              balance = @current_initial_deposit - account.individual_amount_2
            elsif account.account_title_3 == "預金"
              balance = @current_initial_deposit - account.individual_amount_3
            elsif account.account_title_4 == "預金"
              balance = @current_initial_deposit - account.individual_amount_4
            elsif account.account_title_5 == "預金"
              balance = @current_initial_deposit - account.individual_amount_5
            end
          else 
          end
        else
          if account.return_check_box == "1"
            if account.account_title == "預金"
              if account.individual_amount.present?
                balance = @balance + account.individual_amount
              else
                balance = @balance + account.breakdown
              end
            elsif account.account_title_2 == "預金"
              balance = @balance + account.individual_amount_2
            elsif account.account_title_3 == "預金"
              balance = @balance + account.individual_amount_3
            elsif account.account_title_4 == "預金"
              balance = @balance + account.individual_amount_4
            elsif account.account_title_5 == "預金"
              balance = @balance + account.individual_amount_5
            end
          elsif account.return_check_box == "0"
            if account.account_title == "預金"
              if account.individual_amount.present?
                balance = @balance - account.individual_amount
              else
                balance = @balance - account.breakdown
              end
            elsif account.account_title_2 == "預金"
              balance = @balance - account.individual_amount_2
            elsif account.account_title_3 == "預金"
              balance = @balance - account.individual_amount_3
            elsif account.account_title_4 == "預金"
              balance = @balance - account.individual_amount_4
            elsif account.account_title_5 == "預金"
              balance = @balance - account.individual_amount_5
            end
          else 
          end
        end
      end
      a_id = Account.find(account.id)
      a_id.update_attributes(current_balance: balance)
      @balance = balance.to_i
    end
  end
  # -----------------------------------------
  
  # (売上)総勘定元帳用()--controller(create, update, destroy)
  def account_amount_sum
    @general_ledger_accounts = Account.where(subsidiary_journal_species: 4).merge(Account.order("accounts.accounting_date ASC"))
    zero = 0
    @general_ledger_accounts.each do |account|
      if account.return_check_box == "0"
        sum = zero += account.breakdown
      elsif account.return_check_box == "1"
        sum = zero -= account.breakdown
      end
      a_id = Account.find(account.id)
      a_id.update_attributes(general_account_balance: sum)
    end
  end
  # -----------------------------------------
  
  # (売上)総勘定元帳用(１ヶ月毎の借方合計金額と貸方合計金額を比較して、貸借毎の金額を出す。)--controller(general_ledger)
  def account_balance_sum
    # 借方
    zero = 0
    @general_ledger_accounts.each do |account|
      if @this_month.include?(Date.parse(account[:accounting_date].to_s))
        if account.return_check_box == "0"
          if @general_ledger_accounts[0] == account
            if @this_month_last_balance.last.general_account_balance > 0
              @debit_amount = zero += account.breakdown
            else
              @debit_amount = @this_month_last_balance.last.general_account_balance.abs + (zero += account.breakdown)
            end
          else
            if @amount_carried_forward.last.present?
              if @amount_carried_forward.last.general_account_balance <= 0
                if @this_month_last_balance.last.general_account_balance > 0
                  @debit_amount = zero += account.breakdown
                else
                  @debit_amount = @this_month_last_balance.last.general_account_balance.abs + (zero += account.breakdown)
                end
              else
                if @this_month_last_balance.last.general_account_balance < 0
                  @debit_amount = (@amount_carried_forward.last.general_account_balance.abs + @this_month_last_balance.last.general_account_balance.abs) + (zero += account.breakdown)
                else
                  @debit_amount = @amount_carried_forward.last.general_account_balance.abs + (zero += account.breakdown)
                end
              end
            else
              if @this_month_last_balance.last.general_account_balance > 0
                @debit_amount = zero += account.breakdown
              else
                @debit_amount = @this_month_last_balance.last.general_account_balance.abs + (zero += account.breakdown)
              end
            end
          end
        end
      end
    end
    # 貸方
    zero = 0
    @general_ledger_accounts.each do |account|
      if @this_month.include?(Date.parse(account[:accounting_date].to_s))
        if account.return_check_box == "1"
          if @general_ledger_accounts[0] == account
            if @this_month_last_balance.last.general_account_balance < 0
              @credit_amount = zero += account.breakdown
            else
              @credit_amount = @this_month_last_balance.last.general_account_balance.abs + (zero += account.breakdown)
            end
          else
            if @amount_carried_forward.last.present?
              if @amount_carried_forward.last.general_account_balance >= 0
                if @this_month_last_balance.last.general_account_balance < 0
                  @credit_amount = zero += account.breakdown
                else
                  @credit_amount = @this_month_last_balance.last.general_account_balance.abs + (zero += account.breakdown)
                end
              else
                if @this_month_last_balance.last.general_account_balance > 0
                  @credit_amount = (@amount_carried_forward.last.general_account_balance.abs + @this_month_last_balance.last.general_account_balance.abs) + (zero += account.breakdown)
                else
                  @credit_amount = @amount_carried_forward.last.general_account_balance.abs + (zero += account.breakdown)
                end
              end
            else
              if @this_month_last_balance.last.general_account_balance < 0
                @credit_amount = zero += account.breakdown
              else
                @credit_amount = @this_month_last_balance.last.general_account_balance.abs + (zero += account.breakdown)
              end
            end
          end
        end
      end
    end
  end
  # -----------------------------------------
  
  # (仕入)総勘定元帳用()--controller(purchasing_create, purchasing_update, purchasing_destroy)
  def purchasing_amount_sum
    @general_ledger_accounts = Account.where(subsidiary_journal_species: 3).merge(Account.order("accounts.accounting_date ASC"))
    zero = 0
    @general_ledger_accounts.each do |account|
      if account.return_check_box == "0"
        sum = zero += account.breakdown
      elsif account.return_check_box == "1"
        sum = zero -= account.breakdown
      end
      a_id = Account.find(account.id)
      a_id.update_attributes(general_purchasing_balance: sum)
    end
  end
  # -----------------------------------------
  
  # (仕入)総勘定元帳用(１ヶ月毎の借方合計金額と貸方合計金額を比較して、貸借毎の金額を出す。)--controller(purchasing_general_ledger)
  def purchasing_balance_sum
    # 借方
    zero = 0
    @general_ledger_accounts.each do |account|
      if @this_month.include?(Date.parse(account[:accounting_date].to_s))
        if account.return_check_box == "0"
          if @general_ledger_accounts[0] == account
            if @this_month_last_balance.last.general_purchasing_balance > 0
              @debit_amount = zero += account.breakdown
            else
              @debit_amount = @this_month_last_balance.last.general_purchasing_balance.abs + (zero += account.breakdown)
            end
          else
            if @amount_carried_forward.last.present?
              if @amount_carried_forward.last.general_purchasing_balance <= 0
                if @this_month_last_balance.last.general_purchasing_balance > 0
                  @debit_amount = zero += account.breakdown
                else
                  @debit_amount = @this_month_last_balance.last.general_purchasing_balance.abs + (zero += account.breakdown)
                end
              else
                if @this_month_last_balance.last.general_purchasing_balance < 0
                  @debit_amount = (@amount_carried_forward.last.general_purchasing_balance.abs + @this_month_last_balance.last.general_purchasing_balance.abs) + (zero += account.breakdown)
                else
                  @debit_amount = @amount_carried_forward.last.general_purchasing_balance.abs + (zero += account.breakdown)
                end
              end
            else
              if @this_month_last_balance.last.general_purchasing_balance > 0
                @debit_amount = zero += account.breakdown
              else
                @debit_amount = @this_month_last_balance.last.general_purchasing_balance.abs + (zero += account.breakdown)
              end
            end
          end
        end
      end
    end
    # 貸方
    zero = 0
    @general_ledger_accounts.each do |account|
      if @this_month.include?(Date.parse(account[:accounting_date].to_s))
        if account.return_check_box == "1"
          if @general_ledger_accounts[0] == account
            if @this_month_last_balance.last.general_purchasing_balance < 0
              @credit_amount = zero += account.breakdown
            else
              @credit_amount = @this_month_last_balance.last.general_purchasing_balance.abs + (zero += account.breakdown)
            end
          else
            if @amount_carried_forward.last.present?
              if @amount_carried_forward.last.general_purchasing_balance >= 0
                if @this_month_last_balance.last.general_purchasing_balance < 0
                  @credit_amount = zero += account.breakdown
                else
                  @credit_amount = @this_month_last_balance.last.general_purchasing_balance.abs + (zero += account.breakdown)
                end
              else
                if @this_month_last_balance.last.general_purchasing_balance > 0
                  @credit_amount = (@amount_carried_forward.last.general_purchasing_balance.abs + @this_month_last_balance.last.general_purchasing_balance.abs) + (zero += account.breakdown)
                else
                  @credit_amount = @amount_carried_forward.last.general_purchasing_balance.abs + (zero += account.breakdown)
                end
              end
            else
              if @this_month_last_balance.last.general_purchasing_balance < 0
                @credit_amount = zero += account.breakdown
              else
                @credit_amount = @this_month_last_balance.last.general_purchasing_balance.abs + (zero += account.breakdown)
              end
            end
          end
        end
      end
    end
  end
  # -----------------------------------------
  
  # (現金)総勘定元帳用(１ヶ月毎の借方合計金額と貸方合計金額を比較して、貸借毎の金額を出す。)--controller(cash_general_ledger)
  def cash_balance_sum
    # 借方
    zero = 0
    @general_ledger_accounts.each do |account|
      if @this_month.include?(Date.parse(account[:accounting_date].to_s))
        if @general_ledger_accounts[0] == account
          if @this_month_last_balance.last.balance > 0
            if @cash_initial_deposit > 0
              if account.subsidiary_journal_species == 1
                if account.income.present?
                  @debit_amount = @cash_initial_deposit + (zero += account.income)
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "1"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @debit_amount = @cash_initial_deposit + (zero += account.breakdown)
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @debit_amount = @cash_initial_deposit + (zero += account.individual_amount)
                  elsif account.account_title_2 == "現金"
                    @debit_amount = @cash_initial_deposit + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "現金"
                    @debit_amount = @cash_initial_deposit + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "現金"
                    @debit_amount = @cash_initial_deposit + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "現金"
                    @debit_amount = @cash_initial_deposit + (zero += account.individual_amount_5)
                  else
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "0"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @debit_amount = @cash_initial_deposit + (zero += account.breakdown)
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @debit_amount = @cash_initial_deposit + (zero += account.individual_amount)
                  elsif account.account_title_2 == "現金"
                    @debit_amount = @cash_initial_deposit + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "現金"
                    @debit_amount = @cash_initial_deposit + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "現金"
                    @debit_amount = @cash_initial_deposit + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "現金"
                    @debit_amount = @cash_initial_deposit + (zero += account.individual_amount_5)
                  else
                  end
                end
              else
              end
            else
              if account.subsidiary_journal_species == 1
                if account.income.present?
                  @debit_amount = zero += account.income
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "1"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @debit_amount = zero += account.breakdown
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @debit_amount = zero += account.individual_amount
                  elsif account.account_title_2 == "現金"
                    @debit_amount = zero += account.individual_amount_2
                  elsif account.account_title_3 == "現金"
                    @debit_amount = zero += account.individual_amount_3
                  elsif account.account_title_4 == "現金"
                    @debit_amount = zero += account.individual_amount_4
                  elsif account.account_title_5 == "現金"
                    @debit_amount = zero += account.individual_amount_5
                  else
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "0"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @debit_amount = zero += account.breakdown
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @debit_amount = zero += account.individual_amount
                  elsif account.account_title_2 == "現金"
                    @debit_amount = zero += account.individual_amount_2
                  elsif account.account_title_3 == "現金"
                    @debit_amount = zero += account.individual_amount_3
                  elsif account.account_title_4 == "現金"
                    @debit_amount = zero += account.individual_amount_4
                  elsif account.account_title_5 == "現金"
                    @debit_amount = zero += account.individual_amount_5
                  end
                end
              end
            end
          else
            if @cash_initial_deposit > 0
              if account.subsidiary_journal_species == 1
                if account.income.present?
                  @debit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.income)
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "1"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @debit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.breakdown)
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @debit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount)
                  elsif account.account_title_2 == "現金"
                    @debit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "現金"
                    @debit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "現金"
                    @debit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "現金"
                    @debit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_5)
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "0"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @debit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.breakdown)
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @debit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount)
                  elsif account.account_title_2 == "現金"
                    @debit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "現金"
                    @debit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "現金"
                    @debit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "現金"
                    @debit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_5)
                  end
                end
              end
            else
              if account.subsidiary_journal_species == 1
                if account.income.present?
                  @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.income)
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "1"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.breakdown)
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount)
                  elsif account.account_title_2 == "現金"
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "現金"
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "現金"
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "現金"
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_5)
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "0"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.breakdown)
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount)
                  elsif account.account_title_2 == "現金"
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "現金"
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "現金"
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "現金"
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_5)
                  end
                end
              end
            end
          end
        else
          if @amount_carried_forward.last.present?
            if @amount_carried_forward.last.balance <= 0
              if @this_month_last_balance.last.balance > 0
                if account.subsidiary_journal_species == 1
                  if account.income.present?
                    @debit_amount = zero += account.income
                  end
                elsif account.subsidiary_journal_species == 3
                  if account.return_check_box == "1"
                    if account.account_title == "現金" && account.individual_amount.nil?
                      @debit_amount = zero += account.breakdown
                    elsif account.account_title == "現金" && account.individual_amount.present?
                      @debit_amount = zero += account.individual_amount
                    elsif account.account_title_2 == "現金"
                      @debit_amount = zero += account.individual_amount_2
                    elsif account.account_title_3 == "現金"
                      @debit_amount = zero += account.individual_amount_3
                    elsif account.account_title_4 == "現金"
                      @debit_amount = zero += account.individual_amount_4
                    elsif account.account_title_5 == "現金"
                      @debit_amount = zero += account.individual_amount_5
                    else
                    end
                  end
                elsif account.subsidiary_journal_species == 4
                  if account.return_check_box == "0"
                    if account.account_title == "現金" && account.individual_amount.nil?
                      @debit_amount = zero += account.breakdown
                    elsif account.account_title == "現金" && account.individual_amount.present?
                      @debit_amount = zero += account.individual_amount
                    elsif account.account_title_2 == "現金"
                      @debit_amount = zero += account.individual_amount_2
                    elsif account.account_title_3 == "現金"
                      @debit_amount = zero += account.individual_amount_3
                    elsif account.account_title_4 == "現金"
                      @debit_amount = zero += account.individual_amount_4
                    elsif account.account_title_5 == "現金"
                      @debit_amount = zero += account.individual_amount_5
                    else
                    end
                  else
                  end
                end
              else
                if account.subsidiary_journal_species == 1
                  if account.income.present?
                    @debit_amount =  @this_month_last_balance.last.balance.abs + (zero += account.income)
                  end
                elsif account.subsidiary_journal_species == 3
                  if account.return_check_box == "1"
                    if account.account_title == "現金" && account.individual_amount.nil?
                      @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.breakdown)
                    elsif account.account_title == "現金" && account.individual_amount.present?
                      @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount)
                    elsif account.account_title_2 == "現金"
                      @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "現金"
                      @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "現金"
                      @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "現金"
                      @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_5)
                    else
                    end
                  end
                elsif account.subsidiary_journal_species == 4
                  if account.return_check_box == "0"
                    if account.account_title == "現金" && account.individual_amount.nil?
                      @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.breakdown)
                    elsif account.account_title == "現金" && account.individual_amount.present?
                      @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount)
                    elsif account.account_title_2 == "現金"
                      @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "現金"
                      @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "現金"
                      @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "現金"
                      @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_5)
                    else
                    end
                  else
                  end
                end
              end
            else
              if @this_month_last_balance.last.balance < 0
                if account.subsidiary_journal_species == 1
                  if account.income.present?
                    @debit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.income)
                  end
                elsif account.subsidiary_journal_species == 3
                  if account.return_check_box == "1"
                    if account.account_title == "現金" && account.individual_amount.nil?
                      @debit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.breakdown)
                    elsif account.account_title == "現金" && account.individual_amount.present?
                      @debit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount)
                    elsif account.account_title_2 == "現金"
                      @debit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "現金"
                      @debit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "現金"
                      @debit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "現金"
                      @debit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_5)
                    else
                    end
                  end
                elsif account.subsidiary_journal_species == 4
                  if account.return_check_box == "0"
                    if account.account_title == "現金" && account.individual_amount.nil?
                      @debit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.breakdown)
                    elsif account.account_title == "現金" && account.individual_amount.present?
                      @debit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount)
                    elsif account.account_title_2 == "現金"
                      @debit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "現金"
                      @debit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "現金"
                      @debit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "現金"
                      @debit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_5)
                    else
                    end
                  else
                  end
                end
              else
                if account.subsidiary_journal_species == 1
                  if account.income.present?
                    @debit_amount = @amount_carried_forward.last.balance.abs + (zero += account.income)
                  end
                elsif account.subsidiary_journal_species == 3
                  if account.return_check_box == "1"
                    if account.account_title == "現金" && account.individual_amount.nil?
                      @debit_amount = @amount_carried_forward.last.balance.abs + (zero += account.breakdown)
                    elsif account.account_title == "現金" && account.individual_amount.present?
                      @debit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount)
                    elsif account.account_title_2 == "現金"
                      @debit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "現金"
                      @debit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "現金"
                      @debit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "現金"
                      @debit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount_5)
                    else
                    end
                  end
                elsif account.subsidiary_journal_species == 4
                  if account.return_check_box == "0"
                    if account.account_title == "現金" && account.individual_amount.nil?
                      @debit_amount = @amount_carried_forward.last.balance.abs + (zero += account.breakdown)
                    elsif account.account_title == "現金" && account.individual_amount.present?
                      @debit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount)
                    elsif account.account_title_2 == "現金"
                      @debit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "現金"
                      @debit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "現金"
                      @debit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "現金"
                      @debit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount_5)
                    else
                    end
                  else
                  end
                end
              end
            end
          else
            if @this_month_last_balance.last.balance > 0
              if account.subsidiary_journal_species == 1
                if account.income.present?
                  @debit_amount = zero += account.income
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "1"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @debit_amount = zero += account.breakdown
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @debit_amount = zero += account.individual_amount
                  elsif account.account_title_2 == "現金"
                    @debit_amount = zero += account.individual_amount_2
                  elsif account.account_title_3 == "現金"
                    @debit_amount = zero += account.individual_amount_3
                  elsif account.account_title_4 == "現金"
                    @debit_amount = zero += account.individual_amount_4
                  elsif account.account_title_5 == "現金"
                    @debit_amount = zero += account.individual_amount_5
                  else
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "0"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @debit_amount = zero += account.breakdown
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @debit_amount = zero += account.individual_amount
                  elsif account.account_title_2 == "現金"
                    @debit_amount = zero += account.individual_amount_2
                  elsif account.account_title_3 == "現金"
                    @debit_amount = zero += account.individual_amount_3
                  elsif account.account_title_4 == "現金"
                    @debit_amount = zero += account.individual_amount_4
                  elsif account.account_title_5 == "現金"
                    @debit_amount = zero += account.individual_amount_5
                  else
                  end
                else
                end
              end
            else
              if account.subsidiary_journal_species == 1
                if account.income.present?
                  @debit_amount =  @this_month_last_balance.last.balance.abs + (zero += account.income)
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "1"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.breakdown)
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount)
                  elsif account.account_title_2 == "現金"
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "現金"
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "現金"
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "現金"
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_5)
                  else
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "0"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.breakdown)
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount)
                  elsif account.account_title_2 == "現金"
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "現金"
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "現金"
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "現金"
                    @debit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_5)
                  else
                  end
                else
                end
              end
            end
          end
        end
      end
    end
    # 貸方
    zero = 0
    @general_ledger_accounts.each do |account|
      if @this_month.include?(Date.parse(account[:accounting_date].to_s))
        if @general_ledger_accounts[0] == account
          if @this_month_last_balance.last.balance < 0
            if @cash_initial_deposit < 0
              if account.subsidiary_journal_species == 1
                if account.expense.present?
                  @credit_amount = @cash_initial_deposit - (zero += account.expense)
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "0"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @credit_amount = @cash_initial_deposit - (zero += account.breakdown)
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount)
                  elsif account.account_title_2 == "現金"
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "現金"
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "現金"
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "現金"
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount_5)
                  else
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "1"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @credit_amount = @cash_initial_deposit - (zero += account.breakdown)
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount)
                  elsif account.account_title_2 == "現金"
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "現金"
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "現金"
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "現金"
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount_5)
                  else
                  end
                end
              else
              end
            else
              if account.subsidiary_journal_species == 1
                if account.expense.present?
                  @credit_amount = zero += account.expense
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "0"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @credit_amount = zero += account.breakdown
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @credit_amount = zero += account.individual_amount
                  elsif account.account_title_2 == "現金"
                    @credit_amount = zero += account.individual_amount_2
                  elsif account.account_title_3 == "現金"
                    @credit_amount = zero += account.individual_amount_3
                  elsif account.account_title_4 == "現金"
                    @credit_amount = zero += account.individual_amount_4
                  elsif account.account_title_5 == "現金"
                    @credit_amount = zero += account.individual_amount_5
                  else
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "1"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @credit_amount = zero += account.breakdown
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @credit_amount = zero += account.individual_amount
                  elsif account.account_title_2 == "現金"
                    @credit_amount = zero += account.individual_amount_2
                  elsif account.account_title_3 == "現金"
                    @credit_amount = zero += account.individual_amount_3
                  elsif account.account_title_4 == "現金"
                    @credit_amount = zero += account.individual_amount_4
                  elsif account.account_title_5 == "現金"
                    @credit_amount = zero += account.individual_amount_5
                  else
                  end
                end
              else
              end
            end
          else
            if @cash_initial_deposit < 0
              if account.subsidiary_journal_species == 1
                if account.expense.present?
                  @credit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.expense)
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "0"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @credit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.breakdown)
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @credit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount)
                  elsif account.account_title_2 == "現金"
                    @credit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "現金"
                    @credit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "現金"
                    @credit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "現金"
                    @credit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_5)
                  else
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "1"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @credit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.breakdown)
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @credit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount)
                  elsif account.account_title_2 == "現金"
                    @credit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "現金"
                    @credit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "現金"
                    @credit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "現金"
                    @credit_amount = (@cash_initial_deposit + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_5)
                  else
                  end
                end
              end
            else
              if account.subsidiary_journal_species == 1
                if account.expense.present?
                  @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.expense)
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "0"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.breakdown)
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount)
                  elsif account.account_title_2 == "現金"
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "現金"
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "現金"
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "現金"
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_5)
                  else
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "1"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.breakdown)
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount)
                  elsif account.account_title_2 == "現金"
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "現金"
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "現金"
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "現金"
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_5)
                  else
                  end
                end
              end
            end
          end
        else
          if @amount_carried_forward.last.present?
            if @amount_carried_forward.last.balance >= 0
              if @this_month_last_balance.last.balance < 0
                if account.subsidiary_journal_species == 1
                  if account.expense.present?
                    @credit_amount = zero += account.expense
                  end
                elsif account.subsidiary_journal_species == 3
                  if account.return_check_box == "0"
                    if account.account_title == "現金" && account.individual_amount.nil?
                      @credit_amount = zero += account.breakdown
                    elsif account.account_title == "現金" && account.individual_amount.present?
                      @credit_amount = zero += account.individual_amount
                    elsif account.account_title_2 == "現金"
                      @credit_amount = zero += account.individual_amount_2
                    elsif account.account_title_3 == "現金"
                      @credit_amount = zero += account.individual_amount_3
                    elsif account.account_title_4 == "現金"
                      @credit_amount = zero += account.individual_amount_4
                    elsif account.account_title_5 == "現金"
                      @credit_amount = zero += account.individual_amount_5
                    else
                    end
                  end
                elsif account.subsidiary_journal_species == 4
                  if account.return_check_box == "1"
                    if account.account_title == "現金" && account.individual_amount.nil?
                      @credit_amount = zero += account.breakdown
                    elsif account.account_title == "現金" && account.individual_amount.present?
                      @credit_amount = zero += account.individual_amount
                    elsif account.account_title_2 == "現金"
                      @credit_amount = zero += account.individual_amount_2
                    elsif account.account_title_3 == "現金"
                      @credit_amount = zero += account.individual_amount_3
                    elsif account.account_title_4 == "現金"
                      @credit_amount = zero += account.individual_amount_4
                    elsif account.account_title_5 == "現金"
                      @credit_amount = zero += account.individual_amount_5
                    else
                    end
                  else
                  end
                end
              else
                if account.subsidiary_journal_species == 1
                  if account.expense.present?
                    @credit_amount =  @this_month_last_balance.last.balance.abs + (zero += account.expense)
                  end
                elsif account.subsidiary_journal_species == 3
                  if account.return_check_box == "0"
                    if account.account_title == "現金" && account.individual_amount.nil?
                      @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.breakdown)
                    elsif account.account_title == "現金" && account.individual_amount.present?
                      @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount)
                    elsif account.account_title_2 == "現金"
                      @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "現金"
                      @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "現金"
                      @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "現金"
                      @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_5)
                    else
                    end
                  end
                elsif account.subsidiary_journal_species == 4
                  if account.return_check_box == "1"
                    if account.account_title == "現金" && account.individual_amount.nil?
                      @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.breakdown)
                    elsif account.account_title == "現金" && account.individual_amount.present?
                      @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount)
                    elsif account.account_title_2 == "現金"
                      @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "現金"
                      @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "現金"
                      @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "現金"
                      @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_5)
                    else
                    end
                  else
                  end
                end
              end
            else
              if @this_month_last_balance.last.balance > 0
                if account.subsidiary_journal_species == 1
                  if account.expense.present?
                    @credit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.expense)
                  end
                elsif account.subsidiary_journal_species == 3
                  if account.return_check_box == "0"
                    if account.account_title == "現金" && account.individual_amount.nil?
                      @credit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.breakdown)
                    elsif account.account_title == "現金" && account.individual_amount.present?
                      @credit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount)
                    elsif account.account_title_2 == "現金"
                      @credit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "現金"
                      @credit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "現金"
                      @credit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "現金"
                      @credit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_5)
                    else
                    end
                  end
                elsif account.subsidiary_journal_species == 4
                  if account.return_check_box == "1"
                    if account.account_title == "現金" && account.individual_amount.nil?
                      @credit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.breakdown)
                    elsif account.account_title == "現金" && account.individual_amount.present?
                      @credit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount)
                    elsif account.account_title_2 == "現金"
                      @credit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "現金"
                      @credit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "現金"
                      @credit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "現金"
                      @credit_amount = (@amount_carried_forward.last.balance.abs + @this_month_last_balance.last.balance.abs) + (zero += account.individual_amount_5)
                    else
                    end
                  else
                  end
                end
              else
                if account.subsidiary_journal_species == 1
                  if account.expense.present?
                    @credit_amount = @amount_carried_forward.last.balance.abs + (zero += account.expense)
                  end
                elsif account.subsidiary_journal_species == 3
                  if account.return_check_box == "0"
                    if account.account_title == "現金" && account.individual_amount.nil?
                      @credit_amount = @amount_carried_forward.last.balance.abs + (zero += account.breakdown)
                    elsif account.account_title == "現金" && account.individual_amount.present?
                      @credit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount)
                    elsif account.account_title_2 == "現金"
                      @credit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "現金"
                      @credit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "現金"
                      @credit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "現金"
                      @credit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount_5)
                    else
                    end
                  end
                elsif account.subsidiary_journal_species == 4
                  if account.return_check_box == "1"
                    if account.account_title == "現金" && account.individual_amount.nil?
                      @credit_amount = @amount_carried_forward.last.balance.abs + (zero += account.breakdown)
                    elsif account.account_title == "現金" && account.individual_amount.present?
                      @credit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount)
                    elsif account.account_title_2 == "現金"
                      @credit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "現金"
                      @credit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "現金"
                      @credit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "現金"
                      @credit_amount = @amount_carried_forward.last.balance.abs + (zero += account.individual_amount_5)
                    else
                    end
                  else
                  end
                end
              end
            end
          else
            if @this_month_last_balance.last.balance < 0
              if account.subsidiary_journal_species == 1
                if account.expense.present?
                  @credit_amount = zero += account.expense
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "0"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @credit_amount = zero += account.breakdown
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @credit_amount = zero += account.individual_amount
                  elsif account.account_title_2 == "現金"
                    @credit_amount = zero += account.individual_amount_2
                  elsif account.account_title_3 == "現金"
                    @credit_amount = zero += account.individual_amount_3
                  elsif account.account_title_4 == "現金"
                    @credit_amount = zero += account.individual_amount_4
                  elsif account.account_title_5 == "現金"
                    @credit_amount = zero += account.individual_amount_5
                  else
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "1"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @credit_amount = zero += account.breakdown
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @credit_amount = zero += account.individual_amount
                  elsif account.account_title_2 == "現金"
                    @credit_amount = zero += account.individual_amount_2
                  elsif account.account_title_3 == "現金"
                    @credit_amount = zero += account.individual_amount_3
                  elsif account.account_title_4 == "現金"
                    @credit_amount = zero += account.individual_amount_4
                  elsif account.account_title_5 == "現金"
                    @credit_amount = zero += account.individual_amount_5
                  else
                  end
                else
                end
              end
            else
              if account.subsidiary_journal_species == 1
                if account.expense.present?
                  @credit_amount =  @this_month_last_balance.last.balance.abs + (zero += account.expense)
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "0"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.breakdown)
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount)
                  elsif account.account_title_2 == "現金"
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "現金"
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "現金"
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "現金"
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_5)
                  else
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "1"
                  if account.account_title == "現金" && account.individual_amount.nil?
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.breakdown)
                  elsif account.account_title == "現金" && account.individual_amount.present?
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount)
                  elsif account.account_title_2 == "現金"
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "現金"
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "現金"
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "現金"
                    @credit_amount = @this_month_last_balance.last.balance.abs + (zero += account.individual_amount_5)
                  else
                  end
                else
                end
              end
            end
          end
        end
      end
    end
  end
  # -----------------------------------------
  
  # (預金)総勘定元帳用(１ヶ月毎の借方合計金額と貸方合計金額を比較して、貸借毎の金額を出す。)--controller(current_general_ledger)
  def current_balance_sum
    # 借方
    zero = 0
    @general_ledger_accounts.each do |account|
      if @this_month.include?(Date.parse(account[:accounting_date].to_s))
        if @general_ledger_accounts[0] == account
          if @this_month_last_balance.last.current_balance > 0
            if @current_initial_deposit > 0
              if account.subsidiary_journal_species == 2
                if account.deposit.present?
                  @debit_amount = @current_initial_deposit + (zero += account.deposit)
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "1"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @debit_amount = @current_initial_deposit + (zero += account.breakdown)
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @debit_amount = @current_initial_deposit + (zero += account.individual_amount)
                  elsif account.account_title_2 == "預金"
                    @debit_amount = @current_initial_deposit + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "預金"
                    @debit_amount = @current_initial_deposit + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "預金"
                    @debit_amount = @current_initial_deposit + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "預金"
                    @debit_amount = @current_initial_deposit + (zero += account.individual_amount_5)
                  else
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "0"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @debit_amount = @current_initial_deposit + (zero += account.breakdown)
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @debit_amount = @current_initial_deposit + (zero += account.individual_amount)
                  elsif account.account_title_2 == "預金"
                    @debit_amount = @current_initial_deposit + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "預金"
                    @debit_amount = @current_initial_deposit + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "預金"
                    @debit_amount = @current_initial_deposit + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "預金"
                    @debit_amount = @current_initial_deposit + (zero += account.individual_amount_5)
                  else
                  end
                end
              else
              end
            else
              if account.subsidiary_journal_species == 2
                if account.deposit.present?
                  @debit_amount = zero += account.deposit
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "1"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @debit_amount = zero += account.breakdown
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @debit_amount = zero += account.individual_amount
                  elsif account.account_title_2 == "預金"
                    @debit_amount = zero += account.individual_amount_2
                  elsif account.account_title_3 == "預金"
                    @debit_amount = zero += account.individual_amount_3
                  elsif account.account_title_4 == "預金"
                    @debit_amount = zero += account.individual_amount_4
                  elsif account.account_title_5 == "預金"
                    @debit_amount = zero += account.individual_amount_5
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "0"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @debit_amount = zero += account.breakdown
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @debit_amount = zero += account.individual_amount
                  elsif account.account_title_2 == "預金"
                    @debit_amount = zero += account.individual_amount_2
                  elsif account.account_title_3 == "預金"
                    @debit_amount = zero += account.individual_amount_3
                  elsif account.account_title_4 == "預金"
                    @debit_amount = zero += account.individual_amount_4
                  elsif account.account_title_5 == "預金"
                    @debit_amount = zero += account.individual_amount_5
                  end
                end
              end
            end
          else
            if @current_initial_deposit > 0
              if account.subsidiary_journal_species == 2
                if account.deposit.present?
                  @debit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.deposit)
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "1"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @debit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.breakdown)
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @debit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount)
                  elsif account.account_title_2 == "預金"
                    @debit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "預金"
                    @debit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "預金"
                    @debit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "預金"
                    @debit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_5)
                  else
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "0"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @debit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.breakdown)
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @debit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount)
                  elsif account.account_title_2 == "預金"
                    @debit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "預金"
                    @debit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "預金"
                    @debit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "預金"
                    @debit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_5)
                  end
                end
              end
            else
              if account.subsidiary_journal_species == 2
                if account.deposit.present?
                  @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.deposit)
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "1"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.breakdown)
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount)
                  elsif account.account_title_2 == "預金"
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "預金"
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "預金"
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "預金"
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_5)
                  else
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "0"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.breakdown)
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount)
                  elsif account.account_title_2 == "預金"
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "預金"
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "預金"
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "預金"
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_5)
                  end
                end
              end
            end
          end
        else
          if @amount_carried_forward.last.present?
            if @amount_carried_forward.last.current_balance <= 0
              if @this_month_last_balance.last.current_balance > 0
                if account.subsidiary_journal_species == 2
                  if account.deposit.present?
                    @debit_amount = zero += account.deposit
                  end
                elsif account.subsidiary_journal_species == 3
                  if account.return_check_box == "1"
                    if account.account_title == "預金" && account.individual_amount.nil?
                      @debit_amount = zero += account.breakdown
                    elsif account.account_title == "預金" && account.individual_amount.present?
                      @debit_amount = zero += account.individual_amount
                    elsif account.account_title_2 == "預金"
                      @debit_amount = zero += account.individual_amount_2
                    elsif account.account_title_3 == "預金"
                      @debit_amount = zero += account.individual_amount_3
                    elsif account.account_title_4 == "預金"
                      @debit_amount = zero += account.individual_amount_4
                    elsif account.account_title_5 == "預金"
                      @debit_amount = zero += account.individual_amount_5
                    else
                    end
                  end
                elsif account.subsidiary_journal_species == 4
                  if account.return_check_box == "0"
                    if account.account_title == "預金" && account.individual_amount.nil?
                      @debit_amount = zero += account.breakdown
                    elsif account.account_title == "預金" && account.individual_amount.present?
                      @debit_amount = zero += account.individual_amount
                    elsif account.account_title_2 == "預金"
                      @debit_amount = zero += account.individual_amount_2
                    elsif account.account_title_3 == "預金"
                      @debit_amount = zero += account.individual_amount_3
                    elsif account.account_title_4 == "預金"
                      @debit_amount = zero += account.individual_amount_4
                    elsif account.account_title_5 == "預金"
                      @debit_amount = zero += account.individual_amount_5
                    else
                    end
                  else
                  end
                end
              else
                if account.subsidiary_journal_species == 2
                  if account.deposit.present?
                    @debit_amount =  @this_month_last_balance.last.current_balance.abs + (zero += account.deposit)
                  end
                elsif account.subsidiary_journal_species == 3
                  if account.return_check_box == "1"
                    if account.account_title == "預金" && account.individual_amount.nil?
                      @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.breakdown)
                    elsif account.account_title == "預金" && account.individual_amount.present?
                      @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount)
                    elsif account.account_title_2 == "預金"
                      @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "預金"
                      @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "預金"
                      @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "預金"
                      @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_5)
                    else
                    end
                  end
                elsif account.subsidiary_journal_species == 4
                  if account.return_check_box == "0"
                    if account.account_title == "預金" && account.individual_amount.nil?
                      @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.breakdown)
                    elsif account.account_title == "預金" && account.individual_amount.present?
                      @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount)
                    elsif account.account_title_2 == "預金"
                      @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "預金"
                      @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "預金"
                      @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "預金"
                      @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_5)
                    else
                    end
                  else
                  end
                end
              end
            else
              if @this_month_last_balance.last.current_balance < 0
                if account.subsidiary_journal_species == 2
                  if account.deposit.present?
                    @debit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.deposit)
                  end
                elsif account.subsidiary_journal_species == 3
                  if account.return_check_box == "1"
                    if account.account_title == "預金" && account.individual_amount.nil?
                      @debit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.breakdown)
                    elsif account.account_title == "預金" && account.individual_amount.present?
                      @debit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount)
                    elsif account.account_title_2 == "預金"
                      @debit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "預金"
                      @debit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "預金"
                      @debit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "預金"
                      @debit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_5)
                    else
                    end
                  end
                elsif account.subsidiary_journal_species == 4
                  if account.return_check_box == "0"
                    if account.account_title == "預金" && account.individual_amount.nil?
                      @debit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.breakdown)
                    elsif account.account_title == "預金" && account.individual_amount.present?
                      @debit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount)
                    elsif account.account_title_2 == "預金"
                      @debit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "預金"
                      @debit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "預金"
                      @debit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "預金"
                      @debit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_5)
                    else
                    end
                  else
                  end
                end
              else
                if account.subsidiary_journal_species == 2
                  if account.deposit.present?
                    @debit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.deposit)
                  end
                elsif account.subsidiary_journal_species == 3
                  if account.return_check_box == "1"
                    if account.account_title == "預金" && account.individual_amount.nil?
                      @debit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.breakdown)
                    elsif account.account_title == "預金" && account.individual_amount.present?
                      @debit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount)
                    elsif account.account_title_2 == "預金"
                      @debit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "預金"
                      @debit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "預金"
                      @debit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "預金"
                      @debit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount_5)
                    else
                    end
                  end
                elsif account.subsidiary_journal_species == 4
                  if account.return_check_box == "0"
                    if account.account_title == "預金" && account.individual_amount.nil?
                      @debit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.breakdown)
                    elsif account.account_title == "預金" && account.individual_amount.present?
                      @debit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount)
                    elsif account.account_title_2 == "預金"
                      @debit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "預金"
                      @debit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "預金"
                      @debit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "預金"
                      @debit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount_5)
                    end
                  end
                end
              end
            end
          else
            if @this_month_last_balance.last.current_balance > 0
              if account.subsidiary_journal_species == 2
                if account.deposit.present?
                  @debit_amount = zero += account.deposit
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "1"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @debit_amount = zero += account.breakdown
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @debit_amount = zero += account.individual_amount
                  elsif account.account_title_2 == "預金"
                    @debit_amount = zero += account.individual_amount_2
                  elsif account.account_title_3 == "預金"
                    @debit_amount = zero += account.individual_amount_3
                  elsif account.account_title_4 == "預金"
                    @debit_amount = zero += account.individual_amount_4
                  elsif account.account_title_5 == "預金"
                    @debit_amount = zero += account.individual_amount_5
                  else
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "0"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @debit_amount = zero += account.breakdown
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @debit_amount = zero += account.individual_amount
                  elsif account.account_title_2 == "預金"
                    @debit_amount = zero += account.individual_amount_2
                  elsif account.account_title_3 == "預金"
                    @debit_amount = zero += account.individual_amount_3
                  elsif account.account_title_4 == "預金"
                    @debit_amount = zero += account.individual_amount_4
                  elsif account.account_title_5 == "預金"
                    @debit_amount = zero += account.individual_amount_5
                  else
                  end
                else
                end
              end
            else
              if account.subsidiary_journal_species == 2
                if account.deposit.present?
                  @debit_amount =  @this_month_last_balance.last.current_balance.abs + (zero += account.deposit)
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "1"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.breakdown)
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount)
                  elsif account.account_title_2 == "預金"
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "預金"
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "預金"
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "預金"
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_5)
                  else
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "0"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.breakdown)
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount)
                  elsif account.account_title_2 == "預金"
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "預金"
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "預金"
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "預金"
                    @debit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_5)
                  else
                  end
                else
                end
              end
            end
          end
        end
      end
    end
    # 貸方
    zero = 0
    @general_ledger_accounts.each do |account|
      if @this_month.include?(Date.parse(account[:accounting_date].to_s))
        if @general_ledger_accounts[0] == account
          if @this_month_last_balance.last.current_balance < 0
            if @current_initial_deposit < 0
              if account.subsidiary_journal_species == 2
                if account.drawer.present?
                  @credit_amount = @current_initial_deposit - (zero += account.drawer)
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "0"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @credit_amount = @cash_initial_deposit - (zero += account.breakdown)
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount)
                  elsif account.account_title_2 == "預金"
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "預金"
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "預金"
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "預金"
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount_5)
                  else
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "1"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @credit_amount = @cash_initial_deposit - (zero += account.breakdown)
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount)
                  elsif account.account_title_2 == "預金"
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "預金"
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "預金"
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "預金"
                    @credit_amount = @cash_initial_deposit - (zero += account.individual_amount_5)
                  else
                  end
                end
              else
              end
            else
              if account.subsidiary_journal_species == 2
                if account.drawer.present?
                  @credit_amount = zero += account.drawer
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "0"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @credit_amount = zero += account.breakdown
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @credit_amount = zero += account.individual_amount
                  elsif account.account_title_2 == "預金"
                    @credit_amount = zero += account.individual_amount_2
                  elsif account.account_title_3 == "預金"
                    @credit_amount = zero += account.individual_amount_3
                  elsif account.account_title_4 == "預金"
                    @credit_amount = zero += account.individual_amount_4
                  elsif account.account_title_5 == "預金"
                    @credit_amount = zero += account.individual_amount_5
                  else
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "1"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @credit_amount = zero += account.breakdown
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @credit_amount = zero += account.individual_amount
                  elsif account.account_title_2 == "預金"
                    @credit_amount = zero += account.individual_amount_2
                  elsif account.account_title_3 == "預金"
                    @credit_amount = zero += account.individual_amount_3
                  elsif account.account_title_4 == "預金"
                    @credit_amount = zero += account.individual_amount_4
                  elsif account.account_title_5 == "預金"
                    @credit_amount = zero += account.individual_amount_5
                  else
                  end
                end
              else
              end
            end
          else
            if @current_initial_deposit < 0
              if account.subsidiary_journal_species == 2
                if account.drawer.present?
                  @credit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.drawer)
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "0"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @credit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.breakdown)
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @credit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount)
                  elsif account.account_title_2 == "預金"
                    @credit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "預金"
                    @credit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "預金"
                    @credit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "預金"
                    @credit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_5)
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "1"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @credit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.breakdown)
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @credit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount)
                  elsif account.account_title_2 == "預金"
                    @credit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "預金"
                    @credit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "預金"
                    @credit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "預金"
                    @credit_amount = (@current_initial_deposit + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_5)
                  end
                end
              end
            else
              if account.subsidiary_journal_species == 2
                if account.drawer.present?
                  @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.drawer)
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "0"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.breakdown)
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount)
                  elsif account.account_title_2 == "預金"
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "預金"
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "預金"
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "預金"
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_5)
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "1"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.breakdown)
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount)
                  elsif account.account_title_2 == "預金"
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "預金"
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "預金"
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "預金"
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_5)
                  end
                end
              end
            end
          end
        else
          if @amount_carried_forward.last.present?
            if @amount_carried_forward.last.current_balance >= 0
              if @this_month_last_balance.last.current_balance < 0
                if account.subsidiary_journal_species == 2
                  if account.drawer.present?
                    @credit_amount = zero += account.drawer
                  end
                elsif account.subsidiary_journal_species == 3
                  if account.return_check_box == "0"
                    if account.account_title == "預金" && account.individual_amount.nil?
                      @credit_amount = zero += account.breakdown
                    elsif account.account_title == "預金" && account.individual_amount.present?
                      @credit_amount = zero += account.individual_amount
                    elsif account.account_title_2 == "預金"
                      @credit_amount = zero += account.individual_amount_2
                    elsif account.account_title_3 == "預金"
                      @credit_amount = zero += account.individual_amount_3
                    elsif account.account_title_4 == "預金"
                      @credit_amount = zero += account.individual_amount_4
                    elsif account.account_title_5 == "預金"
                      @credit_amount = zero += account.individual_amount_5
                    else
                    end
                  end
                elsif account.subsidiary_journal_species == 4
                  if account.return_check_box == "1"
                    if account.account_title == "預金" && account.individual_amount.nil?
                      @credit_amount = zero += account.breakdown
                    elsif account.account_title == "預金" && account.individual_amount.present?
                      @credit_amount = zero += account.individual_amount
                    elsif account.account_title_2 == "預金"
                      @credit_amount = zero += account.individual_amount_2
                    elsif account.account_title_3 == "預金"
                      @credit_amount = zero += account.individual_amount_3
                    elsif account.account_title_4 == "預金"
                      @credit_amount = zero += account.individual_amount_4
                    elsif account.account_title_5 == "預金"
                      @credit_amount = zero += account.individual_amount_5
                    else
                    end
                  else
                  end
                end
              else
                if account.subsidiary_journal_species == 2
                  if account.drawer.present?
                    @credit_amount =  @this_month_last_balance.last.current_balance.abs + (zero += account.drawer)
                  end
                elsif account.subsidiary_journal_species == 3
                  if account.return_check_box == "0"
                    if account.account_title == "預金" && account.individual_amount.nil?
                      @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.breakdown)
                    elsif account.account_title == "預金" && account.individual_amount.present?
                      @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount)
                    elsif account.account_title_2 == "預金"
                      @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "預金"
                      @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "預金"
                      @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "預金"
                      @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_5)
                    else
                    end
                  end
                elsif account.subsidiary_journal_species == 4
                  if account.return_check_box == "1"
                    if account.account_title == "預金" && account.individual_amount.nil?
                      @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.breakdown)
                    elsif account.account_title == "預金" && account.individual_amount.present?
                      @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount)
                    elsif account.account_title_2 == "預金"
                      @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "預金"
                      @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "預金"
                      @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "預金"
                      @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_5)
                    else
                    end
                  else
                  end
                end
              end
            else
              if @this_month_last_balance.last.current_balance > 0
                if account.subsidiary_journal_species == 2
                  if account.drawer.present?
                    @credit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.drawer)
                  end
                elsif account.subsidiary_journal_species == 3
                  if account.return_check_box == "0"
                    if account.account_title == "預金" && account.individual_amount.nil?
                      @credit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.breakdown)
                    elsif account.account_title == "預金" && account.individual_amount.present?
                      @credit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount)
                    elsif account.account_title_2 == "預金"
                      @credit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "預金"
                      @credit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "預金"
                      @credit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "預金"
                      @credit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_5)
                    else
                    end
                  end
                elsif account.subsidiary_journal_species == 4
                  if account.return_check_box == "1"
                    if account.account_title == "預金" && account.individual_amount.nil?
                      @credit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.breakdown)
                    elsif account.account_title == "預金" && account.individual_amount.present?
                      @credit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount)
                    elsif account.account_title_2 == "預金"
                      @credit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "預金"
                      @credit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "預金"
                      @credit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "預金"
                      @credit_amount = (@amount_carried_forward.last.current_balance.abs + @this_month_last_balance.last.current_balance.abs) + (zero += account.individual_amount_5)
                    else
                    end
                  else
                  end
                end
              else
                if account.subsidiary_journal_species == 2
                  if account.drawer.present?
                    @credit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.drawer)
                  end
                elsif account.subsidiary_journal_species == 3
                  if account.return_check_box == "0"
                    if account.account_title == "預金" && account.individual_amount.nil?
                      @credit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.breakdown)
                    elsif account.account_title == "預金" && account.individual_amount.present?
                      @credit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount)
                    elsif account.account_title_2 == "預金"
                      @credit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "預金"
                      @credit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "預金"
                      @credit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "預金"
                      @credit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount_5)
                    else
                    end
                  end
                elsif account.subsidiary_journal_species == 4
                  if account.return_check_box == "1"
                    if account.account_title == "預金" && account.individual_amount.nil?
                      @credit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.breakdown)
                    elsif account.account_title == "預金" && account.individual_amount.present?
                      @credit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount)
                    elsif account.account_title_2 == "預金"
                      @credit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount_2)
                    elsif account.account_title_3 == "預金"
                      @credit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount_3)
                    elsif account.account_title_4 == "預金"
                      @credit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount_4)
                    elsif account.account_title_5 == "預金"
                      @credit_amount = @amount_carried_forward.last.current_balance.abs + (zero += account.individual_amount_5)
                    else
                    end
                  else
                  end
                end
              end
            end
          else
            if @this_month_last_balance.last.current_balance < 0
              if account.subsidiary_journal_species == 2
                if account.drawer.present?
                  @credit_amount = zero += account.drawer
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "0"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @credit_amount = zero += account.breakdown
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @credit_amount = zero += account.individual_amount
                  elsif account.account_title_2 == "預金"
                    @credit_amount = zero += account.individual_amount_2
                  elsif account.account_title_3 == "預金"
                    @credit_amount = zero += account.individual_amount_3
                  elsif account.account_title_4 == "預金"
                    @credit_amount = zero += account.individual_amount_4
                  elsif account.account_title_5 == "預金"
                    @credit_amount = zero += account.individual_amount_5
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "1"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @credit_amount = zero += account.breakdown
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @credit_amount = zero += account.individual_amount
                  elsif account.account_title_2 == "預金"
                    @credit_amount = zero += account.individual_amount_2
                  elsif account.account_title_3 == "預金"
                    @credit_amount = zero += account.individual_amount_3
                  elsif account.account_title_4 == "預金"
                    @credit_amount = zero += account.individual_amount_4
                  elsif account.account_title_5 == "預金"
                    @credit_amount = zero += account.individual_amount_5
                  end
                end
              end
            else
              if account.subsidiary_journal_species == 2
                if account.drawer.present?
                  @credit_amount =  @this_month_last_balance.last.current_balance.abs + (zero += account.drawer)
                end
              elsif account.subsidiary_journal_species == 3
                if account.return_check_box == "0"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.breakdown)
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount)
                  elsif account.account_title_2 == "預金"
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "預金"
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "預金"
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "預金"
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_5)
                  end
                end
              elsif account.subsidiary_journal_species == 4
                if account.return_check_box == "1"
                  if account.account_title == "預金" && account.individual_amount.nil?
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.breakdown)
                  elsif account.account_title == "預金" && account.individual_amount.present?
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount)
                  elsif account.account_title_2 == "預金"
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_2)
                  elsif account.account_title_3 == "預金"
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_3)
                  elsif account.account_title_4 == "預金"
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_4)
                  elsif account.account_title_5 == "預金"
                    @credit_amount = @this_month_last_balance.last.current_balance.abs + (zero += account.individual_amount_5)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end