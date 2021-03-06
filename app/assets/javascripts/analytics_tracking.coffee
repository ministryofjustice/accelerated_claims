root = exports ? this

class AnalyticsTracking
  constructor: ->
    new root.EventTracker('[data-event-label]')
    new root.EventTracker('#claim_notice_notice_served_no', '/accelerated-possession-eviction/#claim_notice_notice_served_no', 'Accelerated form error', 'You must have given your tenants 2 months notice')

    if @formWithOutErrors()
      trigger_first_interaction = true
      new root.PageviewTracker( trigger_first_interaction )

      if !@referrerIsSelf(document.referrer)
        @dispatchViewFormEvent()

    else if @formWithErrors()
      root.dispatchPageView '/accelerated/validation-error'
      _.each $('.error-link'), @dispatchValidationErrorEvent

    else
      trigger_first_interaction = false
      new root.PageviewTracker( trigger_first_interaction )


  dispatchViewFormEvent: () ->
    root.dispatchTrackingEvent('/accelerated-possession-eviction', 'View service form', 'View service form')

  dispatchValidationErrorEvent: (element) ->
    category = '/accelerated-possession-eviction/' + $(element).data('id')
    category += '_error' unless category.match(/_error$/)
    root.dispatchTrackingEvent(category, 'Accelerated form error', $(element).text() )

  formWithOutErrors: () ->
    ( $('#claimForm').length > 0 ) && ( $('#form_errors').length == 0 )

  formWithErrors: () ->
    ( $('#claimForm').length > 0 ) && ( $('#form_errors').length > 0 )

  referrerIsSelf: (referrer) ->
    if referrer?
      if referrer.match(/dsd\.io/)? || referrer.match(/civilclaims\.service\.gov\.uk/)?
        return true
      else
        return false

root.AnalyticsTracking = AnalyticsTracking

jQuery ->
  new root.AnalyticsTracking()

