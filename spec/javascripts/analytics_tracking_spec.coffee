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
      new window.AnalyticsTracking()
      expect(window.dispatchTrackingEvent).not.toHaveBeenCalled()
      element.remove()

  describe 'click on "data-virtual-pageview" link on page with no #claimForm', ->
    it 'dispatches pageview', ->
      element = $('<body>' +
        '<a id="a_link" data-event-label="data event label" data-virtual-pageview="/clicked_pageview" href="/clicked_event">Link event text</a>' +
        '</body>')

      $(document.body).append(element)
      new window.AnalyticsTracking()

      spyOn window, 'dispatchTrackingEvent'
      spyOn window, 'dispatchPageView'

      $('#a_link').trigger 'click'

      expect(window.dispatchTrackingEvent).toHaveBeenCalledWith(jasmine.any(String), 'Link event text', 'data event label')
      expect(window.dispatchPageView).toHaveBeenCalledWith('/clicked_pageview')

      element.remove()

  describe 'click on external link on page with no #claimForm', ->
    it 'dispatches pageview', ->
      element = $('<body>' +
        '<a class="a_link" rel="external" href="/external_link">Link event text</a>' +
        '</body>')

      $(document.body).append(element)
      new window.AnalyticsTracking()

      spyOn window, 'dispatchPageView'
      $('.a_link').trigger 'click'

      expect(window.dispatchPageView).toHaveBeenCalledWith('/external_link')

      element.remove()

  describe 'onload of #claimForm', ->
    it 'dispatches event', ->
      element = $('<form id="claimForm"></form>')
      $(document.body).append(element)

      spyOn window, 'dispatchTrackingEvent'
      new window.AnalyticsTracking()
      expect(window.dispatchTrackingEvent).toHaveBeenCalledWith('/accelerated-possession-eviction', 'View service form', 'View service form')
      element.remove()

  describe 'onload of #claimForm with .error-summary', ->

    it 'does not dispatch event if no .error-links', ->
      element = $('<form id="claimForm"><div id="form_errors" class="error-summary" /></form>')
      $(document.body).append(element)

      spyOn window, 'dispatchTrackingEvent'
      new window.AnalyticsTracking()
      expect(window.dispatchTrackingEvent).not.toHaveBeenCalled()
      element.remove()

    it 'dispatches pageview', ->
      element = $('<form id="claimForm"><div id="form_errors" class="error-summary" /></form>')
      $(document.body).append(element)

      spyOn window, 'dispatchPageView'
      new window.AnalyticsTracking()
      expect(window.dispatchPageView).toHaveBeenCalledWith('/accelerated/validation-error')
      element.remove()

    it 'dispatches event per .error-link', ->
      element = $('<form id="claimForm"><div id="form_errors" class="error-summary">' +
        '<a class="error-link" data-id="#claimants" href="#claimants">Question "As the landlord, you’re known as the claimant in this case. How many claimants are there?" not answered</a>' +
        '<a class="error-link" data-id="#claim_property_street_error" href="#claim_property_street_error">Street must be entered</a>' +
        '</div></form>')

      $(document.body).append(element)

      spyOn window, 'dispatchTrackingEvent'
      new window.AnalyticsTracking()
      expect(window.dispatchTrackingEvent).toHaveBeenCalledWith('/accelerated-possession-eviction/#claimants_error', 'Accelerated form error', 'Question "As the landlord, you’re known as the claimant in this case. How many claimants are there?" not answered')
      expect(window.dispatchTrackingEvent).toHaveBeenCalledWith('/accelerated-possession-eviction/#claim_property_street_error', 'Accelerated form error', 'Street must be entered')

      element.remove()
