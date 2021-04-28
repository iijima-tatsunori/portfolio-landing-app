module AccountsHelper
  
  def tax_rates(tax)
    case tax
    when 0 then
      "対象外"
    when 8 then
      "8%"
    when 10 then
      "10%"
    else
      ""
    end
  end
  
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
  
  # 総勘定元帳()---view()
  def carried_forward_balance
    @carried_forward_accounts = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date < @first_day
    end
    @carried_forward_accounts.each do |account|
      account.compound_journals.each do |compound_journal|
        if compound_journal.account_title == @param_account_title
          @carried_forward_balance += compound_journal.amount.to_i
        elsif compound_journal.right_account_title == @param_account_title
          @carried_forward_balance -= compound_journal.right_amount.to_i
        end
      end
    end
    @carried_forward_balance
  end
  
  def this_month_last_balance
    @this_month_last_accounts = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date <= @last_day
    end
    @this_month_last_accounts.each do |account|
      account.compound_journals.each do |compound_journal|
        if compound_journal.account_title == @param_account_title
          @this_month_last_balance += compound_journal.amount.to_i
        elsif compound_journal.right_account_title == @param_account_title
          @this_month_last_balance -= compound_journal.right_amount.to_i
        end
      end
    end
    @this_month_last_balance
  end
  
  def general_ledger_balance(compound_journal)
    @general_ledger_balance += compound_journal.amount.to_i
  end
  
  def right_general_ledger_balance(compound_journal)
    @general_ledger_balance -= compound_journal.right_amount.to_i
  end
  # -----------------------------------------
  
  # 総勘定元帳()---view()
  def sub_carried_forward_balance
    @sub_carried_forward_accounts = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date < @first_day
    end
    @sub_carried_forward_accounts.each do |account|
      account.compound_journals.each do |compound_journal|
        if compound_journal.sub_account_title == @param_account_title
          @sub_carried_forward_balance += compound_journal.amount.to_i
        elsif compound_journal.right_sub_account_title == @param_account_title
          @sub_carried_forward_balance -= compound_journal.right_amount.to_i
        end
      end
    end
    @sub_carried_forward_balance
  end
  
  def sub_this_month_last_balance
    @sub_this_month_last_accounts = @general_ledger_accounts.select do |c_a|
      c_a.accounting_date <= @last_day
    end
    @sub_this_month_last_accounts.each do |account|
      account.compound_journals.each do |compound_journal|
        if compound_journal.sub_account_title == @param_account_title
          @sub_this_month_last_balance += compound_journal.amount.to_i
        elsif compound_journal.right_sub_account_title == @param_account_title
          @sub_this_month_last_balance -= compound_journal.right_amount.to_i
        end
      end
    end
    @sub_this_month_last_balance
  end
  
  def sub_general_ledger_balance(compound_journal)
    @sub_general_ledger_balance += compound_journal.amount.to_i
  end
  
  def sub_right_general_ledger_balance(compound_journal)
    @sub_general_ledger_balance -= compound_journal.right_amount.to_i
  end
  # -----------------------------------------
  
  # 総勘定元帳一覧()---view()
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
      if @left_account_titles
        lam = zero += bb.amount.to_i
      end
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
  
  # 総勘定元帳一覧(補助科目)---view()
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
  
  def all_general_ledger_balance(left, right, ary)
    balance = 0
    @left_account_titles.each do |left_account_title| 
      if ary == left_account_title
        balance = left - right
      end
    end
    
    @right_account_titles.each do |right_account_title| 
      if ary == right_account_title
        balance = right - left
      end
    end
    balance
  end
  # -----------------------------------------
  
  # 損益計算書()---view()
  def amount_of_sales
    @sales = 0
    @sales_accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "売上高"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "売上高"})).merge(Account.order("accounts.accounting_date ASC"))
    @sales_accounts.each do |account|
      account.compound_journals.each do |compound_journal|
        if compound_journal.account_title == "売上高"
          @sales -= compound_journal.amount
        elsif compound_journal.right_account_title == "売上高"
          @sales += compound_journal.right_amount
        end
      end
    end
    @sales
  end
  # -----------------------------------------
end