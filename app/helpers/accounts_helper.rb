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
  
  # 貸借対照表
  # (借方計算式)
  def balance_sheet_left_calc(account_title)
    balance_sheet_left_calc = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      account.compound_journals.each do |compound_journal|
        if compound_journal.account_title == account_title
          balance_sheet_left_calc += compound_journal.amount
        elsif compound_journal.right_account_title == account_title
          balance_sheet_left_calc -= compound_journal.right_amount
        end
      end
    end
    balance_sheet_left_calc
  end
  # (貸方計算式)
  def balance_sheet_right_calc(account_title)
    balance_sheet_right_calc = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      account.compound_journals.each do |compound_journal|
        if compound_journal.account_title == account_title
          balance_sheet_right_calc -= compound_journal.amount
        elsif compound_journal.right_account_title == account_title
          balance_sheet_right_calc += compound_journal.right_amount
        end
      end
    end
    balance_sheet_right_calc
  end
  
  # 仮払消費税
  def left_consumption_tax
    left_consumption_tax = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "仮払消費税"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "仮払消費税"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      account.compound_journals.each do |compound_journal|
        if compound_journal.account_title == "仮払消費税"
          left_consumption_tax -= compound_journal.amount
        elsif compound_journal.right_account_title == "仮払消費税"
          left_consumption_tax += compound_journal.right_amount
        end
      end
    end
    left_consumption_tax
  end
  # 仮受消費税
  def right_consumption_tax
    right_consumption_tax = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "仮受消費税"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "仮受消費税"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      account.compound_journals.each do |compound_journal|
        if compound_journal.account_title == "仮受消費税"
          right_consumption_tax -= compound_journal.amount
        elsif compound_journal.right_account_title == "仮受消費税"
          right_consumption_tax += compound_journal.right_amount
        end
      end
    end
    right_consumption_tax
  end
  
  # 未払消費税等
  def accrued_consumption_tax
    right_consumption_tax + left_consumption_tax
  end
  # -----------------------------------------
  
  
  # 損益計算書
  # (売上高)
  def amount_of_sales
    sales = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "売上"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "売上"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "売上"
            sales -= compound_journal.amount
          elsif compound_journal.right_account_title == "売上"
            sales += compound_journal.right_amount
          end
        end
      end
    end
    sales
  end
  # (売上原価)
  def cost_of_sales
    beginning_of_term + purchase + end_of_term - outsourcing_cost
  end
  # (期首商品棚卸高)
  def beginning_of_term
    beginning = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "期首商品棚卸高"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "期首商品棚卸高"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "期首商品棚卸高"
            beginning -= compound_journal.amount
          elsif compound_journal.right_account_title == "期首商品棚卸高"
            beginning += compound_journal.right_amount
          end
        end
      end
    end
    beginning
  end
  # (当期商品仕入高)
  def purchase
    purchase = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "仕入"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "仕入"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "仕入"
            purchase -= compound_journal.amount
          elsif compound_journal.right_account_title == "仕入"
            purchase += compound_journal.right_amount
          end
        end
      end
    end
    purchase
  end
  # (期末商品棚卸高)
  def end_of_term
    end_of_term = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "期末商品棚卸高"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "期末商品棚卸高"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "期末商品棚卸高"
            end_of_term -= compound_journal.amount
          elsif compound_journal.right_account_title == "期末商品棚卸高"
            end_of_term += compound_journal.right_amount
          end
        end
      end
    end
    end_of_term
  end
  # (外注加工費)
  def outsourcing_cost
    outsourcing_cost = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "外注加工費"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "外注加工費"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "外注加工費"
            outsourcing_cost -= compound_journal.amount
          elsif compound_journal.right_account_title == "外注加工費"
            outsourcing_cost += compound_journal.right_amount
          end
        end
      end
    end
    outsourcing_cost
  end
  # (売上総利益)
  def gross_profit
    amount_of_sales - cost_of_sales
  end
  
  # (販売費及一般管理費)
  def administrative_expenses
    salary + rent_paid + depreciation_and_amortization + allowance_for_doubtful_accounts
  end
  # (給料)
  def salary
    salary = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "給料手当"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "給料手当"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "給料手当"
            salary -= compound_journal.amount
          elsif compound_journal.right_account_title == "給料手当"
            salary += compound_journal.right_amount
          end
        end
      end
    end
    salary
  end
  # (支払家賃)
  def rent_paid
    rent_paid = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "地代家賃"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "地代家賃"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "地代家賃"
            rent_paid -= compound_journal.amount
          elsif compound_journal.right_account_title == "地代家賃"
            rent_paid += compound_journal.right_amount
          end
        end
      end
    end
    rent_paid
  end
  # (減価償却費)
  def depreciation_and_amortization
    depreciation_and_amortization = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "減価償却費"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "減価償却費"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "減価償却費"
            depreciation_and_amortization -= compound_journal.amount
          elsif compound_journal.right_account_title == "減価償却費"
            depreciation_and_amortization += compound_journal.right_amount
          end
        end
      end
    end
    depreciation_and_amortization
  end
  # (貸倒引当金繰入)
  def allowance_for_doubtful_accounts
    allowance_for_doubtful_accounts = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "貸倒金"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "貸倒金"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "貸倒金"
            allowance_for_doubtful_accounts -= compound_journal.amount
          elsif compound_journal.right_account_title == "貸倒金"
            allowance_for_doubtful_accounts += compound_journal.right_amount
          end
        end
      end
    end
    allowance_for_doubtful_accounts
  end
  # (営業利益)
  def operating_income
    gross_profit + administrative_expenses
  end
  
   # (受取利息)
  def interest_income
    interest_income = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "受取利息"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "受取利息"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "受取利息"
            interest_income -= compound_journal.amount
          elsif compound_journal.right_account_title == "受取利息"
            interest_income += compound_journal.right_amount
          end
        end
      end
    end
    interest_income
  end
  # (有価証券利息)
  def interest_on_marketable_securities
    interest_on_marketable_securities = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "有価証券利息"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "有価証券利息"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "有価証券利息"
            interest_on_marketable_securities -= compound_journal.amount
          elsif compound_journal.right_account_title == "有価証券利息"
            interest_on_marketable_securities += compound_journal.right_amount
          end
        end
      end
    end
    interest_on_marketable_securities
  end
  # (有価証券売却益)
  def gain_on_sales_of_marketable_securities
    gain_on_sales_of_marketable_securities = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "有価証券売却益"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "有価証券売却益"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "有価証券売却益"
            gain_on_sales_of_marketable_securities -= compound_journal.amount
          elsif compound_journal.right_account_title == "有価証券売却益"
            gain_on_sales_of_marketable_securities += compound_journal.right_amount
          end
        end
      end
    end
    gain_on_sales_of_marketable_securities
  end
  # (受取配当金)
  def dividend_income
    dividend_income = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "受取配当金"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "受取配当金"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "受取配当金"
            dividend_income -= compound_journal.amount
          elsif compound_journal.right_account_title == "受取配当金"
            dividend_income += compound_journal.right_amount
          end
        end
      end
    end
    dividend_income
  end
  # (営業外収益)
  def non_operating_income
     interest_income + interest_on_marketable_securities + gain_on_sales_of_marketable_securities + dividend_income
  end
  
  # (支払利息)
  def interest_expense
    interest_expense = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "支払利息"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "支払利息"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "支払利息"
            interest_expense -= compound_journal.amount
          elsif compound_journal.right_account_title == "支払利息"
            interest_expense += compound_journal.right_amount
          end
        end
      end
    end
    interest_expense
  end
  # (社債利息)
  def interest_on_bonds
    interest_on_bonds = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "社債利息"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "社債利息"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "社債利息"
            interest_on_bonds -= compound_journal.amount
          elsif compound_journal.right_account_title == "社債利息"
            interest_on_bonds += compound_journal.right_amount
          end
        end
      end
    end
    interest_on_bonds
  end
  # (有価証券評価損)
  def loss_on_valuation_of_marketable_securities
    loss_on_valuation_of_marketable_securities = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "有価証券評価損"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "有価証券評価損"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "有価証券評価損"
            loss_on_valuation_of_marketable_securities -= compound_journal.amount
          elsif compound_journal.right_account_title == "有価証券評価損"
            loss_on_valuation_of_marketable_securities += compound_journal.right_amount
          end
        end
      end
    end
    loss_on_valuation_of_marketable_securities
  end
  # (雑損失)
  def miscellaneous_losses
    miscellaneous_losses = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "雑損失"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "雑損失"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "雑損失"
            miscellaneous_losses -= compound_journal.amount
          elsif compound_journal.right_account_title == "雑損失"
            miscellaneous_losses += compound_journal.right_amount
          end
        end
      end
    end
    miscellaneous_losses
  end
  # (営業外費用)
  def non_operating_expenses
     interest_expense + interest_on_bonds + loss_on_valuation_of_marketable_securities + miscellaneous_losses
  end
  # (経常利益)
  def ordinary_income
     non_operating_expenses + operating_income + non_operating_income
  end
  
  # (固定資産売却益)
  def gain_on_sales_of_fixed_assets
    gain_on_sales_of_fixed_assets = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "固定資産売却益"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "固定資産売却益"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "固定資産売却益"
            gain_on_sales_of_fixed_assets -= compound_journal.amount
          elsif compound_journal.right_account_title == "固定資産売却益"
            gain_on_sales_of_fixed_assets += compound_journal.right_amount
          end
        end
      end
    end
    gain_on_sales_of_fixed_assets
  end
  
  # (火災損失)
  def fire_loss
    fire_loss = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "火災損失"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "火災損失"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "火災損失"
            fire_loss -= compound_journal.amount
          elsif compound_journal.right_account_title == "火災損失"
            fire_loss += compound_journal.right_amount
          end
        end
      end
    end
    fire_loss
  end
  
  # (税引前当期純利益)
  def current_net_benefit_before_tax_citation
    ordinary_income + fire_loss + gain_on_sales_of_fixed_assets
  end
  
  # (法人税･住民税及び事業税)
  def corporate_inhabitant_and_enterprise_taxes
    corporate_inhabitant_and_enterprise_taxes = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: "法人税･住民税及び事業税"}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: "法人税･住民税及び事業税"})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      if @this_year.include?(Date.parse(account[:accounting_date].to_s))
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == "法人税･住民税及び事業税"
            corporate_inhabitant_and_enterprise_taxes -= compound_journal.amount
          elsif compound_journal.right_account_title == "法人税･住民税及び事業税"
            corporate_inhabitant_and_enterprise_taxes += compound_journal.right_amount
          end
        end
      end
    end
    corporate_inhabitant_and_enterprise_taxes
  end
  
  # (当期純利益)
  def current_net_benefit_tax_citation
     current_net_benefit_before_tax_citation + corporate_inhabitant_and_enterprise_taxes
  end
  # -----------------------------------------
end