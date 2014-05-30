root = exports ? this

class AnalyticsTracking
  constructor: ($) ->
    new root.EventTracker( $ )

    if @formWithOutErrors( $ )
      new root.PageviewTracker( $ )

      if !@referrerIsSelf(document.referrer)
        root.dispatchTrackingEvent('/accelerated-possession-eviction', 'View service form', 'View service form')

  formWithOutErrors: ($) ->
    ( $('#claimForm').length > 0 ) && ( $('.error-summary').length == 0 )

  referrerIsSelf: (referrer) ->
    if referrer?
      if referrer.match(/dsd\.io/)? || referrer.match(/civilclaims\.service\.gov\.uk/)?
        return true
      else
        return false

root.AnalyticsTracking = AnalyticsTracking

jQuery ->
  new root.AnalyticsTracking( $ )

