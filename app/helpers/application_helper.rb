module ApplicationHelper
  def nav(show_nav)
    @show_nav = show_nav
  end

  # true if nav is true or nil (unspecified)
  def nav?
    @show_nav != false
  end
end
