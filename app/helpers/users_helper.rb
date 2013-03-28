module UsersHelper
  def edit_user_submit_text(user)
    if @user.new_record?
      t('helpers.links.sign_up')
    else
      t('helpers.links.save')
    end
  end
end
