//= require jquery
//= require jasmine-jquery
//= require event_tracker
//= require pageview_tracker
//= require analytics_tracking

element = null

beforeEach ->
  element = $('<form id="claimForm">' +
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
        spyOn window, 'dispatchPageView'
        $('#radio_input').trigger 'click'

        expect(window.dispatchPageView).toHaveBeenCalledWith('/radio')

    describe 'on second click', ->
      it 'does not dispatch pageview', ->
        $('#radio_input').trigger 'click'

        spyOn window, 'dispatchPageView'
        $('#radio_input').trigger 'click'

        expect(window.dispatchPageView).not.toHaveBeenCalled()

describe 'EventTracker', ->
  describe 'click on "data-event-label" element', ->
    it "dispatches analytics event", ->
      track = new window.EventTracker($)

      spyOn window, 'dispatchTrackingEvent'
      $('[data-event-label]').trigger 'click'

      expect(window.dispatchTrackingEvent).toHaveBeenCalledWith '/clicked', 'Link text', 'data event label'

describe 'AnalyticsTracking', ->
  describe 'onload of #claimForm', ->
    it 'dispatches event', ->
      spyOn window, 'dispatchTrackingEvent'
      new window.AnalyticsTracking($)
      expect(window.dispatchTrackingEvent).toHaveBeenCalledWith('/accelerated-possession-eviction', 'View service form', 'View service form')

  describe 'onload of #claimForm with .error-summary', ->
    it 'does not dispatch event', ->
      element.remove() # remove form
      errorForm = $('<form id="claimForm"><div class="error-summary" /></form>')
      $(document.body).append(errorForm)

      spyOn window, 'dispatchTrackingEvent'
      new window.AnalyticsTracking($)
      expect(window.dispatchTrackingEvent).not.toHaveBeenCalled()

  describe 'onload of non-form', ->
    it 'does not dispatch event', ->
      element.remove() # remove form
      $(document.body).append(element)

      spyOn window, 'dispatchTrackingEvent'
      new window.AnalyticsTracking($)
      expect(window.dispatchTrackingEvent).not.toHaveBeenCalled()


