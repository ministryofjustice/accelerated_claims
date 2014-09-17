root = exports ? this

ErrorFocusModule = 

  focusOnErrorSection: ->
    if $('#form_errors').length > 0
      $('#form_errors').focus()

  setup: ->
    ErrorFocusModule.focusOnErrorSection()


root.ErrorFocusModule = ErrorFocusModule

jQuery ->
  ErrorFocusModule.setup()