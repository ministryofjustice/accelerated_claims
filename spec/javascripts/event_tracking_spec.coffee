//= require jquery
//= require jasmine-jquery
//= require event_tracking
//= require helpers/with_html

element = null

beforeEach ->
  element = $('<form><a data-event-label="data event label" href="/clicked">Link text</a></form>')
  $(document.body).append(element)


afterEach ->
  element.remove()
  element = null


describe 'Event tracking', ->
  it "dispatches analytics event on click of 'data-event-label' attributed element", ->
    track = new window.EventTrack($)

    spyOn(track, 'dispatchTrackingEvent')
    $('[data-event-label]').trigger('click')

    expect(track.dispatchTrackingEvent).toHaveBeenCalledWith('/clicked', 'Link text', 'data event label')

