root = exports ? this

root.dispatchPageView = (url) ->
  ga 'send', 'pageview', url if typeof ga is 'function'

class PageviewTracker
  constructor: ($) ->
    @sentPageviews = new Object()

    textInput = $('input[type="text"][data-virtual-pageview]')
    inputs = $('input[data-virtual-pageview]')
    links = $('a[data-virtual-pageview]')
    external_links = $('a[rel="external"]')

    @bind textInput, 'focusout', @onFocusOut
    @bind inputs, 'click', @onClick
    @bind links, 'click', @onClick
    @bind external_links, 'click', @onClick
    @bindDynamicallyCreatedElements()

  bindDynamicallyCreatedElements: () ->
    $(document).on 'click', '#multiplePanelRadio_claimants_1', @onClick
    $(document).on 'click', '#multiplePanelRadio_claimants_2', @onClick
    $(document).on 'click', '#multiplePanelRadio_defendants_1', @onClick
    $(document).on 'click', '#multiplePanelRadio_defendants_2', @onClick

  bind: (elements, event, handler) ->
    _.each elements, (element) =>
      selector = '#' + element.id
      $(document).on event, selector, handler

  unbind: (url, event, handler) ->
    items = $('[data-virtual-pageview="' + url + '"]')
    items = $('[href="' + url + '"]') if items.size() == 0
    _.each items, (item) ->
      selector = '#' + item.id
      $(document).off event, selector, handler

  onFocusOut: (event) =>
    element = event.currentTarget
    if element.value.length > 0
      element = event.currentTarget
      url = $(element).data('virtual-pageview')
      root.dispatchPageView url
      @unbind url, 'focusout', @onFocusOut
    return true

  onClick: (event) =>
    element = event.currentTarget
    if element.type != 'text'
      url = $(element).data('virtual-pageview')
      url = $(element).attr('href') if !url
      root.dispatchPageView url
      @unbind url, 'click', @onClick
    return true

root.PageviewTracker = PageviewTracker

