$ ->
  $('#forgot_password').on 'click', (evt) ->
    $('#reset-password').slideDown(100).find('#reset_email').focus()
    evt.preventDefault()
    false