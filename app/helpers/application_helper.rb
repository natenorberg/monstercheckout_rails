module ApplicationHelper

  # Renders the full title for the page
  def full_title(page_title)
    base_title = 'MONSTER Checkout'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end  

  def bootstrap_class_for(flash_type)
    case flash_type
    when 'success'
      'alert-success'
    when 'notice'
      'alert-warning'
    when 'error'
      'alert-danger'
    else
      flash_type.to_s
    end
  end

  def is_monitor_action?(controller, action)
    if controller == 'monitor'
      true
    elsif controller == 'reservations'
       action == 'checkout' || action == 'checkin'
    end
  end

  def version_number
    '1.0.0 Development'
  end
  
end
