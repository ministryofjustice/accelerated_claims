root = exports ? this

root.dispatchPageView = (url) ->
    ga 'send', 'pageview', url if typeof ga is 'function'

class PageviewTracker
  constructor: ($) ->
    @sentPageviews = new Object()

    textInput = $('input[type="text"][data-virtual-pageview]')
    inputs = $('input[data-virtual-pageview]')

    textInput.on 'focusout', @onFocusOut
    inputs.on 'click', @onClick

  onFocusOut: (event) ->
    if @value.length > 0
      url = $(this).data('virtual-pageview')
      root.dispatchPageView url
      $(this).off 'focusout', @onFocusOut
    return true

  onClick: (event) ->
    if @type != 'text'
      url = $(this).data('virtual-pageview')
      root.dispatchPageView url
      $(this).off 'click', @onClick
    return true

root.PageviewTracker = PageviewTracker

