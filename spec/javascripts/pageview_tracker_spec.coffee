//= require underscore
//= require jquery
//= require jasmine-jquery
//= require pageview_tracker

describe 'PageviewTracker', ->
  element = null
  track = null

  beforeEach ->
    element = $('<body><form id="claimForm">' +
      '<a id="a_link" data-event-label="data event label" data-virtual-pageview="/clicked_pageview" href="/clicked_event">Link event text</a>' +
      '<input data-virtual-pageview="/text" id="text_input" type="text" />' +
      '<input data-virtual-pageview="/radio" id="radio_input" type="radio" value="Yes" />' +
      '<input data-virtual-pageview="/radio" id="radio_input_no" type="radio" value="No" />' +
      '</form></body>')
    $(document.body).append(element)
    track = new window.PageviewTracker($)

  afterEach ->
    element.remove()
    element = null

  describe '"data-virtual-pageview" anchor link', ->
    describe 'on first click', ->
      it 'dispatches pageview', ->
        spyOn window, 'dispatchPageView'
        $('#a_link').trigger 'click'

        expect(window.dispatchPageView).toHaveBeenCalledWith('/clicked_pageview')

    describe 'on second click', ->
      it 'does not dispatch pageview', ->
        $('#a_link').trigger 'click'
        spyOn window, 'dispatchPageView'
        $('#a_link').trigger 'click'

        expect(window.dispatchPageView).not.toHaveBeenCalled()

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

    describe 'on click two inputs with same pageview path', ->
      it 'does not dispatch pageview', ->
        $('#radio_input').trigger 'click'
        spyOn window, 'dispatchPageView'
        $('#radio_input_no').trigger 'click'

        expect(window.dispatchPageView).not.toHaveBeenCalled()

  describe 'focusout on "data-virtual-pageview" text input', ->
    describe 'when input contains text', ->
      it 'dispatches virtual pageview', ->
        spyOn window, 'dispatchPageView'
        textInput = $('#text_input')
        textInput.val('something entered')
        textInput.focusout()

        expect(window.dispatchPageView).toHaveBeenCalled()

    describe 'on second focus out', ->
      it 'does not dispatch virtual pageview', ->
        textInput = $('#text_input')
        textInput.val('something entered')
        textInput.focusout()
        spyOn window, 'dispatchPageView'
        textInput.focusout()
        expect(window.dispatchPageView).not.toHaveBeenCalled()

    describe 'when input does not contain text', ->
      it 'does not dispatch virtual pageview', ->
        spyOn window, 'dispatchPageView'
        textInput = $('#text_input')
        textInput.focusout()

        expect(window.dispatchPageView).not.toHaveBeenCalled()

