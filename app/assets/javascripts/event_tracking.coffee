root = exports ? this

referrerIsSelf = (referrer) ->
  if referrer?
    if referrer.match(/dsd\.io/)? || referrer.match(/civilclaims\.service\.gov\.uk/)?
      return true
    else
      return false

jQuery ->
  new root.EventTracker( $ )

  if $('#claimForm').length > 0
    if $('.error-summary').length == 0
      if !referrerIsSelf(document.referrer)
        ga 'send', 'event', '/accelerated-possession-eviction', 'View service form', 'View service form' if typeof ga is 'function'

      new root.PageviewTracker( $ )

