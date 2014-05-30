root = exports ? this

class PageviewTracker
  constructor: ($) ->
    @sentPageviews = new Object()

    textInput = $('input[type="text"][data-virtual-pageview]')
    inputs = $('input[data-virtual-pageview]')

    textInput.on 'focusout', { tracker: this }, @onFocusOut
    inputs.on 'click', { tracker: this }, @onClick

  onFocusOut: (event) ->
    if @value.length > 0
      url = $(this).data('virtual-pageview')
      event.data.tracker.triggerPageView url
    return true

  onClick: (event) ->
    if @type != 'text'
      url = $(this).data('virtual-pageview')
      event.data.tracker.triggerPageView url
    return true

  triggerPageView: (url) ->
    newPageview = !(@sentPageviews[url]?) || (!@sentPageviews[url])
    if newPageview
      alert(url)
      @dispatchPageView(url)
      @sentPageviews[url] = true

  dispatchPageView: (url) ->
    ga 'send', 'pageview', url if typeof ga is 'function'

root.PageviewTracker = PageviewTracker

