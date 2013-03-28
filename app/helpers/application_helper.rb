module ApplicationHelper
  def nav(show_nav)
    @show_nav = show_nav
  end

  # true if nav is true or nil (unspecified)
  def nav?
    @show_nav != false
  end

  def twitterized(flash_type)
    case flash_type
      when :alert   then "warning"
      when :error   then "error"
      when :notice  then "info"
      when :success then "success"
      else               flash_type.to_s
    end
  end
end
