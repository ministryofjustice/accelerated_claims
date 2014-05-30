root = exports ? this

class EventTracker
  constructor: ($) ->
    $('[data-event-label]').on 'click', { tracker: this }, @onClick

  onClick: (event) ->
    category = this['href'].replace(/https?:\/\/[^\/]+/i, '')
    action = this.text
    label = $(this).data('event-label')
    event.data.tracker.dispatchTrackingEvent(category, action, label)
    $(this).off 'click', @onClick
    return true

  dispatchTrackingEvent: (category, action, label) ->
    ga 'send', 'event', category, action, label if typeof ga is 'function'

root.EventTracker = EventTracker

