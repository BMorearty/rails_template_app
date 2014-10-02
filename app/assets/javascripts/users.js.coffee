showFeedbackOnSubmit = ->
  $('form.new_user, form.edit_user').on 'submit', ->
    $(this).find('.actions input[name=commit]').attr('disabled','disabled').addClass('disabled')

$ ->
  showFeedbackOnSubmit()
