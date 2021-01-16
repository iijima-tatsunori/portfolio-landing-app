module AccountsHelper
  
  def accounts_sum(a, s)
    a.update_attributes(amount: s)
  end
  
  def i_number(a_1, i)
    a_1.update_attributes(continue_check_box: i)
  end
  
  def account_sum(a, b)
    a.update_attributes(amount: b)
  end
  
  def clear_check(a_1)
    if a_1.continue_check_box.present?
      a_1.update_attributes(continue_check_box: nil)
    end
  end
  
end