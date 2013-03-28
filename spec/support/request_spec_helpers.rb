# To get these helpers:
#
#   class ActionDispatch::IntegrationTest
#     include IntegrationTestHelpers
#   end
module RequestSpecHelpers
  attr_reader :current_user

  # After login the browser will be pointing to root_path.  There's no need to "visit root_path".
  def request_login(user=nil)
    @current_user = user || FactoryGirl.create(:user)
    #page.driver.post user_sessions_url, { email: @current_user.email, password: 'secret' }
    visit '/login'
    fill_in 'email', with: @current_user.email
    fill_in 'password', with: 'secret'
    click_button 'Login'
  end

  def request_logout
    click_link 'Logout'
  end
end
