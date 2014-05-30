//= require jquery
//= require jasmine-jquery
//= require event_tracker
//= require pageview_tracker
//= require event_tracking
//= require helpers/with_html

element = null

beforeEach ->
  element = $('<form>' +
    '<a data-event-label="data event label" href="/clicked">Link text</a>' +
    '<input data-virtual-pageview="/accelerated/notice_section" id="text_input" type="text" />' +
    '<input data-virtual-pageview="/accelerated/property-section" id="radio_input" type="radio" value="Yes" />' +
    '</form>')
  $(document.body).append(element)

afterEach ->
  element.remove()
  element = null

describe 'Focusout on "data-virtual-pageview" text input', ->
  it 'dispatches virtual pageview when input contains text', ->
    track = new window.PageviewTracker($)

    spyOn track, 'dispatchPageView'
    input = $('#text_input')
    input.value = 'something entered'
    input.focusout()

    setTimeout( (-> expect(track.dispatchPageView).toHaveBeenCalled() ), 0)

describe 'Click on "data-virtual-pageview" non-text input', ->
  it 'dispatches virtual pageview on first click', ->
    track = new window.PageviewTracker($)

    spyOn track, 'dispatchPageView'
    $('#radio_input').trigger 'click'

    expect(track.dispatchPageView).toHaveBeenCalled()

  it 'does not dispatch virtual pageview on second click', ->
    track = new window.PageviewTracker($)
    $('#radio_input').trigger 'click'
    spyOn track, 'dispatchPageView'
    $('#radio_input').trigger 'click'

    expect(track.dispatchPageView).not.toHaveBeenCalled()

describe 'Click on "data-event-label" element', ->
  it "dispatches analytics event", ->
    track = new window.EventTracker($)

    spyOn track, 'dispatchTrackingEvent'
    $('[data-event-label]').trigger 'click'

    expect(track.dispatchTrackingEvent).toHaveBeenCalledWith '/clicked', 'Link text', 'data event label'

