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

  describe 'onload of form with .error-summary', ->

    it 'dispatches event per error', ->
      element = $('<form id="claimForm"><div class="error-summary">' +
        '<a class="error-link" data-id="#claimants" href="#claimants">Question "As the landlord, you’re known as the claimant in this case. How many claimants are there?" not answered</a>' +
        '<a class="error-link" data-id="#claim_property_street_error" href="#claim_property_street_error">Street must be entered</a>' +
        '</div></form>')

      $(document.body).append(element)

      spyOn window, 'dispatchTrackingEvent'
      new window.AnalyticsTracking($)
      expect(window.dispatchTrackingEvent).toHaveBeenCalledWith('/accelerated-possession-eviction/#claimants_error', 'Accelerated form error', 'Question "As the landlord, you’re known as the claimant in this case. How many claimants are there?" not answered')
      expect(window.dispatchTrackingEvent).toHaveBeenCalledWith('/accelerated-possession-eviction/#claim_property_street_error', 'Accelerated form error', 'Street must be entered')

      element.remove()

