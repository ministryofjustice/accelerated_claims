root = exports ? this

root.dispatchPageView = (url) ->
  ga 'send', 'pageview', url if typeof ga is 'function'

class PageviewTracker
  constructor: ( trigger_first_interaction ) ->
    @sentPageviews = new Object()

    textInput = $('input[type="text"][data-virtual-pageview]')
    inputs = $('input[data-virtual-pageview]')
    links = $('a[data-virtual-pageview]')
    external_links = $('a[rel="external"]')
    @xx_link_counter = 0
    @first_interaction = trigger_first_interaction      # always false if first-interaction pageview not to be triggered

    @bind textInput, 'focusout', @onFocusOut
    @bind inputs, 'click', @onClick
    @bind links, 'click', @onClick
    @bind external_links, 'click', @onClick
    @bindDynamicallyCreatedElements()

  construct_xx_link: ->
    @xx_link_counter++
    "xx-link-" + @xx_link_counter

  record_first_interaction: ->
    if @first_interaction
      url = '/accelerated/first-interaction'
      root.dispatchPageView url
      @first_interaction = false

  bindDynamicallyCreatedElements: () ->
    $(document).on 'click', '#multiplePanelRadio_claimants_1', @onClick
    $(document).on 'click', '#multiplePanelRadio_claimants_2', @onClick
    $(document).on 'click', '#multiplePanelRadio_defendants_1', @onClick
    $(document).on 'click', '#multiplePanelRadio_defendants_2', @onClick

  bind: (elements, event, handler) ->
    _.each elements, (element) =>

      if !element.id
        $(element).attr('id', @construct_xx_link())
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
      @record_first_interaction()
      element = event.currentTarget
      url = $(element).data('virtual-pageview')
      root.dispatchPageView url
      @unbind url, 'focusout', @onFocusOut
    return true

  onClick: (event) =>
    element = event.currentTarget
    if element.type != 'text'
      @record_first_interaction()
      url = $(element).data('virtual-pageview')
      url = $(element).attr('href') if !url
      root.dispatchPageView url
      @unbind url, 'click', @onClick
    return true

root.PageviewTracker = PageviewTracker

