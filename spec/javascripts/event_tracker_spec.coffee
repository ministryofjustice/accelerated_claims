//= require jquery
//= require jasmine-jquery
//= require event_tracker

describe 'EventTracker', ->

  describe 'click on "data-event-label" element', ->
    it "dispatches analytics event", ->
      element = $('<form id="claimForm">' +
        '<a id="a_link" data-event-label="data event label" data-virtual-pageview="/clicked_pageview" href="/clicked_event">Link event text</a>' +
        '</form>')
      $(document.body).append(element)

      track = new window.EventTracker($)
      spyOn window, 'dispatchTrackingEvent'
      $('[data-event-label]').trigger 'click'

      expect(window.dispatchTrackingEvent).toHaveBeenCalledWith(jasmine.any(String), 'Link event text', 'data event label')
      element.remove()

