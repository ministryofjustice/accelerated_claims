root = exports ? this

root.dispatchTrackingEvent = (category, action, label) ->
  ga 'send', 'event', category, action, label if typeof ga is 'function'

class EventTracker
  constructor: (selector, event_action=null, event_label=null) ->
    @action = event_action
    @label = event_label
    @bind $(selector), @onClick

  bind: (elements, handler) ->
    _.each elements, (element) =>
      selector = '#' + element.id
      $('body').on 'click', selector, handler

  unbind: (element) ->
    selector = '#' + element.id
    $('body').off 'click', selector, @onClick

  onClick: (event) =>
    element = event.currentTarget
    category = element['href'].replace(/https?:\/\/[^\/]+/i, '')
    action = @action || element.text
    label = @label || $(element).data('event-label')

    root.dispatchTrackingEvent(category, action, label)
    @unbind element
    return true

root.EventTracker = EventTracker

