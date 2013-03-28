$ ->
  $('#forgot_password').on 'click', (evt) ->
    $('#reset_password').slideDown(100).find('#reset_email').focus()
    evt.preventDefault()
    false