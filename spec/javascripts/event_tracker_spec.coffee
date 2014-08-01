//= require jquery
//= require jasmine-jquery
//= require event_tracker

describe 'EventTracker', ->
  element = null

  beforeEach ->
    element = $('<form id="claimForm">' +
      '<a id="a_link" data-event-label="data event label" data-virtual-pageview="/clicked_pageview" href="/clicked_event">Link event text</a>' +
      '</form>')
    $(document.body).append(element)

  afterEach ->
    element.remove()
    element = null

  describe 'click on "data-event-label" element', ->
    it "dispatches analytics event", ->
      track = new window.EventTracker('[data-event-label]')
      spyOn window, 'dispatchTrackingEvent'
      $('[data-event-label]').trigger 'click'

      expect(window.dispatchTrackingEvent).toHaveBeenCalledWith(jasmine.any(String), 'Link event text', 'data event label')

  describe 'click on "data-event-label" element with overrides', ->
    it "dispatches analytics event with overriden action/label", ->
      track = new window.EventTracker('[data-event-label]', 'new action', 'new label')
      spyOn window, 'dispatchTrackingEvent'
      $('[data-event-label]').trigger 'click'

      expect(window.dispatchTrackingEvent).toHaveBeenCalledWith(jasmine.any(String), 'new action', 'new label')

  describe 'second click on "data-event-label" element', ->
    it "does not dispatch analytics event", ->
      track = new window.EventTracker('[data-event-label]')
      $('[data-event-label]').trigger 'click'
      spyOn window, 'dispatchTrackingEvent'

      expect(window.dispatchTrackingEvent).not.toHaveBeenCalled()

