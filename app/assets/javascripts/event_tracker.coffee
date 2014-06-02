root = exports ? this

root.dispatchTrackingEvent = (category, action, label) ->
    ga 'send', 'event', category, action, label if typeof ga is 'function'

class EventTracker
  constructor: ($) ->
    $('[data-event-label]').on 'click', @onClick

  onClick: (event) ->
    category = this['href'].replace(/https?:\/\/[^\/]+/i, '')
    action = this.text
    label = $(this).data('event-label')
    root.dispatchTrackingEvent(category, action, label)
    $(this).off 'click', @onClick
    return true

root.EventTracker = EventTracker

