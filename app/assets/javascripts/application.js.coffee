# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require jquery.turbolinks
#= require jquery.fittext
#= require_tree .
#= require turbolinks

showUserLinks = ->
  email = Cookie.get('email')
  if email
    email = decodeURIComponent(email.replace('+',' '))
    $('#current_user_email').text("#{email} ▾")
    $('#signup, .orlogin, #login').hide()
  else
    $('#usermenu').hide()

# For browsers that don't recognize the HTML5 autofocus attribute
autoFocus = ->
  $('[autofocus]:not(:focus)').eq(0).focus()

$(document).on 'click', (evt) ->
  if $(evt.target).hasClass('popup-parent')
    $(evt.target).next('.popup-menu').toggle()
  else
    $('.popup-menu').hide()

$ ->
  showUserLinks()
  autoFocus()
