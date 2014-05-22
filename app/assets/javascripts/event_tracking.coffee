dispatchTrackingEvent = (category, action, label) ->
  ga 'send', 'event', category, action, label if typeof ga is 'function'

dispatchPageView = (url) ->
  ga 'send', 'pageview', url if typeof ga is 'function'

referrerIsSelf = (referrer) ->
  if referrer?
    if referrer.match(/dsd\.io/)? || referrer.match(/civilclaims\.service\.gov\.uk/)?
      return true
    else
      return false

jQuery ->
  $('[data-event-label]').on 'click', ->
    category = this['href'].replace(/https?:\/\/[^\/]+/i, '')
    action = @text
    label = $(this).data('event-label')
    dispatchTrackingEvent category, action, label
    return true

  if $('#claimForm').length > 0
    if !referrerIsSelf(document.referrer)
      dispatchPageView '/new'

    if $('.error-summary').length == 0
      $(document).on 'click', '[data-virtual-pageview]', ->
        url = $(this).data('virtual-pageview')
        alert(url)
        dispatchPageView url
        return true

