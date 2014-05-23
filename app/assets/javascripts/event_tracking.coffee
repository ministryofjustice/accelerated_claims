dispatchTrackingEvent = (category, action, label) ->
  ga 'send', 'event', category, action, label if typeof ga is 'function'

dispatchPageView = (url) ->
  new_pageview = !($.sent_pageviews[url]?) || (!$.sent_pageviews[url])
  if new_pageview
    ga 'send', 'pageview', url if typeof ga is 'function'
    $.sent_pageviews[url] = true

referrerIsSelf = (referrer) ->
  if referrer?
    if referrer.match(/dsd\.io/)? || referrer.match(/civilclaims\.service\.gov\.uk/)?
      return true
    else
      return false

jQuery ->
  $.sent_pageviews = new Object()

  $('[data-event-label]').on 'click', ->
    category = this['href'].replace(/https?:\/\/[^\/]+/i, '')
    action = @text
    label = $(this).data('event-label')
    dispatchTrackingEvent category, action, label
    return true

  if $('#claimForm').length > 0
    if $('.error-summary').length == 0
      if !referrerIsSelf(document.referrer)
        dispatchTrackingEvent '/accelerated-possession-eviction', 'View service form', 'View service form'

      $(document).on 'focusout', '[data-virtual-pageview]', ->
        if @value.length > 0
          url = $(this).data('virtual-pageview')
          dispatchPageView url
          return true

      $(document).on 'click', '[data-virtual-pageview]', ->
        if @type != 'text'
          url = $(this).data('virtual-pageview')
          dispatchPageView url
          return true

