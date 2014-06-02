//= require jquery
//= require jasmine-jquery
//= require event_tracker
//= require pageview_tracker
//= require analytics_tracking

describe 'AnalyticsTracking', ->
  describe 'onload of non-form', ->
    it 'does not dispatch event', ->
      element = $('<body></body>')
      $(document.body).append(element)

      spyOn window, 'dispatchTrackingEvent'
      new window.AnalyticsTracking($)
      expect(window.dispatchTrackingEvent).not.toHaveBeenCalled()
      element.remove()

  describe 'onload of #claimForm', ->

    it 'dispatches event', ->
      element = $('<form id="claimForm"></form>')
      $(document.body).append(element)

      spyOn window, 'dispatchTrackingEvent'
      new window.AnalyticsTracking($)
      expect(window.dispatchTrackingEvent).toHaveBeenCalledWith('/accelerated-possession-eviction', 'View service form', 'View service form')
      element.remove()

  describe 'onload of #claimForm with .error-summary', ->

    it 'does not dispatch event', ->
      element = $('<form id="claimForm"><div class="error-summary" /></form>')
      $(document.body).append(element)

      spyOn window, 'dispatchTrackingEvent'
      new window.AnalyticsTracking($)
      expect(window.dispatchTrackingEvent).not.toHaveBeenCalled()
      element.remove()

