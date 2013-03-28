showFeedbackOnSubmit = ->
  $('form.new_user, form.edit_user').on 'submit', ->
    $(this).find('.form-actions input[name=commit]').attr('disabled','disabled').addClass('disabled')
    # TODO:
    #   pleaseWait = => RailsTemplateApp.flash.notice('Sending you an email. Please wait...')
    #   setTimeout pleaseWait, 500

$ ->
  showFeedbackOnSubmit()
