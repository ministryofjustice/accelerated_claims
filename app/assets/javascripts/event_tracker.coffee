root = exports ? this

root.dispatchTrackingEvent = (category, action, label) ->
    ga 'send', 'event', category, action, label if typeof ga is 'function'

class EventTracker
  constructor: ($) ->
    @bind $('[data-event-label]'), 'click', @onClick

  bind: (elements, event, handler) ->
    _.each( elements, (element) =>
      selector = '#' + element.id
      $('body').on event, selector, handler )

  onClick: (event) ->
    category = this['href'].replace(/https?:\/\/[^\/]+/i, '')
    action = this.text
    label = $(this).data('event-label')
    root.dispatchTrackingEvent(category, action, label)
    selector = '#' + this.id
    $('body').off 'click', selector, @onClick
    return true

root.EventTracker = EventTracker

