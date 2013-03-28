jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()

  # Convert Rails error class to Bootstrap error class.
  $(".field_with_errors").closest(".control-group").addClass("error")