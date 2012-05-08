module ApplicationHelper
  def full_title(page_title)
    base_title = "One Spark"
    
    if page_title.empty?
      return base_title
    else
      return "#{base_title} | #{page_title}"
    end
  end
  
end
