module ApplicationHelper

  # Renders the full title for the page
  def full_title(page_title)
    base_title = "MONSTER Checkout"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end  

  def bootstrap_class_for(flash_type)
    case flash_type
    when 'success'
      "alert-success"
    when 'notice'
      "alert-warning"
    when 'error'
      "alert-danger"
    else
      flash_type.to_s
    end
  end
  
end
