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
  
  # 貸借対照表、損益計算書共通
  # (借方計算式)
  def left_calc(account_title)
    left_calc = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      account.compound_journals.each do |compound_journal|
        if compound_journal.account_title == account_title
          left_calc += compound_journal.amount
        elsif compound_journal.right_account_title == account_title
          left_calc -= compound_journal.right_amount
        end
      end
    end
    left_calc
  end
  # (貸方計算式)
  def right_calc(account_title)
    right_calc = 0
    accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
    accounts.each do |account|
      account.compound_journals.each do |compound_journal|
        if compound_journal.account_title == account_title
          right_calc -= compound_journal.amount
        elsif compound_journal.right_account_title == account_title
          right_calc += compound_journal.right_amount
        end
      end
    end
    right_calc
  end
  
  
  # 貸借対照表
  # (現金/預金合計)
  def cash_deposits_sum
    @cash_deposits_sum = 0
    @cash_deposits.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == account_title
            @cash_deposits_sum += compound_journal.amount
          elsif compound_journal.right_account_title == account_title
            @cash_deposits_sum -= compound_journal.right_amount
          end
        end
      end
    end
    @cash_deposits_sum
  end
  # (棚卸資産合計)
  def trade_receivables_sum
    @trade_receivables_sum = 0
    @trade_receivables.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == account_title
            @trade_receivables_sum += compound_journal.amount
          elsif compound_journal.right_account_title == account_title
            @trade_receivables_sum -= compound_journal.right_amount
          end
        end
      end
    end
    @trade_receivables_sum
  end
  # (売上債権合計)
  def inventories_sum
    @inventories_sum = 0
    @inventories.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == account_title
            @inventories_sum += compound_journal.amount
          elsif compound_journal.right_account_title == account_title
            @inventories_sum -= compound_journal.right_amount
          end
        end
      end
    end
    @inventories_sum
  end
  # (他流動資産合計)
  def other_current_assets_sum
    @other_current_assets_sum = 0
    @other_current_assets.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == account_title
            @other_current_assets_sum += compound_journal.amount
          elsif compound_journal.right_account_title == account_title
            @other_current_assets_sum -= compound_journal.right_amount
          end
        end
      end
    end
    @other_current_assets_sum
  end
  
  # (流動資産合計)
  def current_assets_sum
    @other_current_assets_sum + @inventories_sum + @trade_receivables_sum + @cash_deposits_sum
  end
  
  # (有形固定資産合計)
  def tangible_fixed_assets_sum
    @tangible_fixed_assets_sum = 0
    @tangible_fixed_assets.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == account_title
            @tangible_fixed_assets_sum += compound_journal.amount
          elsif compound_journal.right_account_title == account_title
            @tangible_fixed_assets_sum -= compound_journal.right_amount
          end
        end
      end
    end
    @tangible_fixed_assets_sum
  end
  # (無形固定資産合計)
  def intangible_fixed_assets_sum
    @intangible_fixed_assets_sum = 0
    @intangible_fixed_assets.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == account_title
            @intangible_fixed_assets_sum += compound_journal.amount
          elsif compound_journal.right_account_title == account_title
            @intangible_fixed_assets_sum -= compound_journal.right_amount
          end
        end
      end
    end
    @intangible_fixed_assets_sum
  end
  
  # (固定資産合計)
  def fixed_assets_sum
    @tangible_fixed_assets_sum + @intangible_fixed_assets_sum
  end
  
  # (繰延資産合計)
  def deferred_assets_sum
    @deferred_assets_sum = 0
    @deferred_assets.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == account_title
            @deferred_assets_sum += compound_journal.amount
          elsif compound_journal.right_account_title == account_title
            @deferred_assets_sum -= compound_journal.right_amount
          end
        end
      end
    end
    @deferred_assets_sum
  end
  
  # (資産合計)
  def assets_sum
    fixed_assets_sum + current_assets_sum
  end
  
  # (仕入債務合計)
  def accounts_payable_trades_sum
    @accounts_payable_trades_sum = 0
    @accounts_payable_trades.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == account_title
            @accounts_payable_trades_sum -= compound_journal.amount
          elsif compound_journal.right_account_title == account_title
            @accounts_payable_trades_sum += compound_journal.right_amount
          end
        end
      end
    end
    @accounts_payable_trades_sum
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
  
  # (他流動負債合計)
  def other_current_liabilities_sum
    other_current_liabilities_sum = 0
    @other_current_liabilities.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == account_title
            other_current_liabilities_sum -= compound_journal.amount
          elsif compound_journal.right_account_title == account_title
            other_current_liabilities_sum += compound_journal.right_amount
          end
        end
      end
    end
    @other_current_liabilities_sum = other_current_liabilities_sum + accrued_consumption_tax
  end
  
  # (流動負債合計)
  def current_liabilities_sum
    @accounts_payable_trades_sum + @other_current_liabilities_sum
  end
  
  # (固定負債合計)
  def fixed_liabilities_sum
    @fixed_liabilities_sum = 0
    @fixed_liabilities.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == account_title
            @fixed_liabilities_sum -= compound_journal.amount
          elsif compound_journal.right_account_title == account_title
            @fixed_liabilities_sum += compound_journal.right_amount
          end
        end
      end
    end
    @fixed_liabilities_sum
  end
  
  # (負債合計)
  def liabilities_sum
    current_liabilities_sum + @fixed_liabilities_sum
  end
  
  
  # (資本金合計)
  def capital_stocks_sum
    @capital_stocks_sum = 0
    @capital_stocks.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == account_title
            @capital_stocks_sum -= compound_journal.amount
          elsif compound_journal.right_account_title == account_title
            @capital_stocks_sum += compound_journal.right_amount
          end
        end
      end
    end
    @capital_stocks_sum
  end
  
  # (利益剰余金)
  def retained_earnings_sum
    @retained_earnings_sum = 0
    @retained_earnings.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        account.compound_journals.each do |compound_journal|
          if compound_journal.account_title == account_title
            @retained_earnings_sum -= compound_journal.amount
          elsif compound_journal.right_account_title == account_title
            @retained_earnings_sum += compound_journal.right_amount
          end
        end
      end
    end
    @retained_earnings_sum
  end
  
  # (利益剰余金合計)
  def retained_earnings_amount_sum
    current_net_income + retained_earnings_sum
  end
  
  # (純資産合計)
  def net_assets_sum
    @capital_stocks_sum + retained_earnings_amount_sum
  end
  
  # (負債/純資産合計)
  def liabilities_and_net_assets_sum
    net_assets_sum + liabilities_sum
  end
  # -----------------------------------------
  
  
  
  
  
  
  
  
  
  # 損益計算書
  # (売上高)
  def amount_of_sales_sum
    @amount_of_sales_sum = 0
    @amount_of_sales.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        if @this_year.include?(Date.parse(account[:accounting_date].to_s))
          account.compound_journals.each do |compound_journal|
            if compound_journal.account_title == account_title
              @amount_of_sales_sum -= compound_journal.amount
            elsif compound_journal.right_account_title == account_title
              @amount_of_sales_sum += compound_journal.right_amount
            end
          end
        end
      end
    end
    @amount_of_sales_sum
  end
  # (売上原価)
  def cost_of_sales_sum
    @cost_of_sales_sum = 0
    @cost_of_sales.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        if @this_year.include?(Date.parse(account[:accounting_date].to_s))
          account.compound_journals.each do |compound_journal|
            if compound_journal.account_title == account_title
              @cost_of_sales_sum -= compound_journal.amount
            elsif compound_journal.right_account_title == account_title
              @cost_of_sales_sum += compound_journal.right_amount
            end
          end
        end
      end
    end
    @cost_of_sales_sum
  end
  # (売上総利益)
  def gross_profit
    amount_of_sales_sum + cost_of_sales_sum
  end
  
  # (販売費及一般管理費)
  def administrative_expenses_sum
    @administrative_expenses_sum = 0
    @administrative_expenses.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        if @this_year.include?(Date.parse(account[:accounting_date].to_s))
          account.compound_journals.each do |compound_journal|
            if compound_journal.account_title == account_title
              @administrative_expenses_sum += compound_journal.amount
            elsif compound_journal.right_account_title == account_title
              @administrative_expenses_sum -= compound_journal.right_amount
            end
          end
        end
      end
    end
    @administrative_expenses_sum
  end
  
  # (営業利益)
  def operating_income
    gross_profit - administrative_expenses_sum
  end
  
   
  # (営業外収益)
  def non_operating_income_sum
    @non_operating_income_sum = 0
    @non_operating_income.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        if @this_year.include?(Date.parse(account[:accounting_date].to_s))
          account.compound_journals.each do |compound_journal|
            if compound_journal.account_title == account_title
              @non_operating_income_sum -= compound_journal.amount
            elsif compound_journal.right_account_title == account_title
              @non_operating_income_sum += compound_journal.right_amount
            end
          end
        end
      end
    end
    @non_operating_income_sum
  end
  
  
  # (営業外費用)
  def non_operating_expenses_sum
    @non_operating_expenses_sum = 0
    @non_operating_expenses.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        if @this_year.include?(Date.parse(account[:accounting_date].to_s))
          account.compound_journals.each do |compound_journal|
            if compound_journal.account_title == account_title
              @non_operating_expenses_sum += compound_journal.amount
            elsif compound_journal.right_account_title == account_title
              @non_operating_expenses_sum -= compound_journal.right_amount
            end
          end
        end
      end
    end
    @non_operating_expenses_sum
  end
  # (経常利益)
  def ordinary_income
    operating_income + non_operating_income_sum - non_operating_expenses_sum
  end
  
  # (特別利益)
  def extraordinary_gains_sum
    @extraordinary_gains_sum = 0
    @extraordinary_gains.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        if @this_year.include?(Date.parse(account[:accounting_date].to_s))
          account.compound_journals.each do |compound_journal|
            if compound_journal.account_title == account_title
              @extraordinary_gains_sum -= compound_journal.amount
            elsif compound_journal.right_account_title == account_title
              @extraordinary_gains_sum += compound_journal.right_amount
            end
          end
        end
      end
    end
    @extraordinary_gains_sum
  end
  
  # (特別損失)
  def extraordinary_loss_sum
    @extraordinary_loss_sum = 0
    @extraordinary_loss.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        if @this_year.include?(Date.parse(account[:accounting_date].to_s))
          account.compound_journals.each do |compound_journal|
            if compound_journal.account_title == account_title
              @extraordinary_loss_sum -= compound_journal.amount
            elsif compound_journal.right_account_title == account_title
              @extraordinary_loss_sum += compound_journal.right_amount
            end
          end
        end
      end
    end
    @extraordinary_loss_sum
  end
  
  
  # (税引前当期純利益)
  def current_net_benefit_before_tax_citation
    ordinary_income + extraordinary_gains_sum + extraordinary_loss_sum
  end
  
  # (法人税･住民税及び事業税)
  def corporate_inhabitant_and_enterprise_taxes_sum
    @corporate_inhabitant_and_enterprise_taxes_sum = 0
    @corporate_inhabitant_and_enterprise_taxes.each do |account_title|
      accounts = Account.joins(:compound_journals).where(compound_journals: {account_title: account_title}).or(Account.joins(:compound_journals).where(compound_journals: {right_account_title: account_title})).merge(Account.order("accounts.accounting_date ASC"))
      accounts.each do |account|
        if @this_year.include?(Date.parse(account[:accounting_date].to_s))
          account.compound_journals.each do |compound_journal|
            if compound_journal.account_title == account_title
              @corporate_inhabitant_and_enterprise_taxes_sum -= compound_journal.amount
            elsif compound_journal.right_account_title == account_title
              @corporate_inhabitant_and_enterprise_taxes_sum += compound_journal.right_amount
            end
          end
        end
      end
    end
    @corporate_inhabitant_and_enterprise_taxes_sum
  end
  
  # 当期純利益
  def current_net_income
    current_net_benefit_before_tax_citation + corporate_inhabitant_and_enterprise_taxes_sum
  end
  
  
  # -----------------------------------------
end