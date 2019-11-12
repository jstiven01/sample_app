module ApplicationHelper
     # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def button_text(button_text = '')
    base_text = "Submit"
    if button_text.empty?
      base_text
    else
      button_text
    end
  end
end
