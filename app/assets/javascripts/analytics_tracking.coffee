root = exports ? this

class AnalyticsTracking
  constructor: ($) ->
    new root.EventTracker( $ )

    if $('#claimForm').length > 0
      if $('.error-summary').length == 0
        if !@referrerIsSelf(document.referrer)
          root.dispatchTrackingEvent('/accelerated-possession-eviction', 'View service form', 'View service form')

        new root.PageviewTracker( $ )

  referrerIsSelf: (referrer) ->
    if referrer?
      if referrer.match(/dsd\.io/)? || referrer.match(/civilclaims\.service\.gov\.uk/)?
        return true
      else
        return false

root.AnalyticsTracking = AnalyticsTracking

jQuery ->
  new root.AnalyticsTracking( $ )

