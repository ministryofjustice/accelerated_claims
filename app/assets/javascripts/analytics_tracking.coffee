root = exports ? this

class AnalyticsTracking
  constructor: ($) ->
    new root.EventTracker( $ )

    if @formWithOutErrors( $ )
      new root.PageviewTracker( $ )

      if !@referrerIsSelf(document.referrer)
        @dispatchViewFormEvent()

    else if @formWithErrors( $ )
      _.each $('.error-link'), @dispatchValidationErrorEvent

    else
      new root.PageviewTracker( $ )


  dispatchViewFormEvent: () ->
    root.dispatchTrackingEvent('/accelerated-possession-eviction', 'View service form', 'View service form')

  dispatchValidationErrorEvent: (element) ->
    category = '/accelerated-possession-eviction/' + $(element).data('id')
    category += '_error' unless category.match(/_error$/)
    root.dispatchTrackingEvent(category, 'Accelerated form error', $(element).text() )

  formWithOutErrors: ($) ->
    ( $('#claimForm').length > 0 ) && ( $('.error-summary').length == 0 )

  formWithErrors: ($) ->
    ( $('#claimForm').length > 0 ) && ( $('.error-summary').length > 0 )

  referrerIsSelf: (referrer) ->
    if referrer?
      if referrer.match(/dsd\.io/)? || referrer.match(/civilclaims\.service\.gov\.uk/)?
        return true
      else
        return false

root.AnalyticsTracking = AnalyticsTracking

jQuery ->
  new root.AnalyticsTracking( $ )

