//= require jquery
//= require jasmine-jquery
//= require event_tracker
//= require pageview_tracker
//= require event_tracking

element = null

beforeEach ->
  element = $('<form>' +
    '<a data-event-label="data event label" href="/clicked">Link text</a>' +
    '<input data-virtual-pageview="/text" id="text_input" type="text" />' +
    '<input data-virtual-pageview="/radio" id="radio_input" type="radio" value="Yes" />' +
    '</form>')
  $(document.body).append(element)

afterEach ->
  element.remove()
  element = null

describe 'PageviewTracker', ->
  track = null

  beforeEach ->
    track = new window.PageviewTracker($)

  describe '"data-virtual-pageview" non-text input', ->

    describe 'on first click', ->
      it 'dispatches pageview', ->
        spyOn track, 'dispatchPageView'
        $('#radio_input').trigger 'click'

        expect(track.dispatchPageView).toHaveBeenCalledWith('/radio')

    describe 'on second click', ->
      it 'does not dispatch pageview', ->
        $('#radio_input').trigger 'click'
        spyOn track, 'dispatchPageView'
        $('#radio_input').trigger 'click'

        expect(track.dispatchPageView).not.toHaveBeenCalled()

describe 'EventTracker', ->
  describe 'click on "data-event-label" element', ->
    it "dispatches analytics event", ->
      track = new window.EventTracker($)

      spyOn track, 'dispatchTrackingEvent'
      $('[data-event-label]').trigger 'click'

      expect(track.dispatchTrackingEvent).toHaveBeenCalledWith '/clicked', 'Link text', 'data event label'

