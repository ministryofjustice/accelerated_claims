jQuery ->

  dispatchTrackingEvent: (category, action, label) ->
    ga 'send', 'event', category, action, label if typeof ga is 'function'

  dispatchPageView: (url) ->
    ga 'send', 'pageview', url if typeof ga is 'function'

  $('[data-event-label]').on 'click', ->
    category = this['href'].replace(/https?:\/\/[^\/]+/i, '')
    action = @text
    label = $(this).data('event-label')
    dispatchTrackingEvent category, action, label
    return true

  $('[data-virtual-pageview]').on 'click', ->
    url = $(this).data('virtual-pageview')
    dispatchPageView url
    return true

  return
