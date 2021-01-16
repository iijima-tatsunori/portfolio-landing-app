module ApplicationHelper
  
  def full_title(page_name = "")
    base_title = "有限会社○○○○"
    if page_name.empty?
      base_title
    else
      page_name + "|" + base_title
    end
  end
  
end
