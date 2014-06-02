root = exports ? this

root.dispatchPageView = (url) ->
    ga 'send', 'pageview', url if typeof ga is 'function'

class PageviewTracker
  constructor: ($) ->
    @sentPageviews = new Object()

    textInput = $('input[type="text"][data-virtual-pageview]')
    inputs = $('input[data-virtual-pageview]')
    links = $('a[data-virtual-pageview]')

    @bind textInput, 'focusout', @onFocusOut
    @bind inputs, 'click', @onClick
    @bind links, 'click', @onClick

  bind: (elements, event, handler) ->
    _.each( elements, (element) =>
      selector = '#' + element.id
      $('body').on event, selector, handler )

  onFocusOut: (event) ->
    if @value.length > 0
      url = $(this).data('virtual-pageview')
      root.dispatchPageView url
      selector = '#' + this.id
      $('body').off 'focusout', selector, @onFocusOut
    return true

  onClick: (event) ->
    if @type != 'text'
      url = $(this).data('virtual-pageview')
      root.dispatchPageView url
      selector = '#' + this.id
      $('body').off 'click', selector, @onClick
    return true

root.PageviewTracker = PageviewTracker

