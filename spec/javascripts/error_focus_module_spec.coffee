//= require underscore
//= require jquery
//= require jasmine-jquery
//= require error_focus_module


describe 'ErrorFocusModule', ->

  describe 'setup', ->
    it 'should call focusOnErrorSection()', ->
      spyOn window.ErrorFocusModule, 'focusOnErrorSection'
      ErrorFocusModule.setup()
      expect(window.ErrorFocusModule.focusOnErrorSection).toHaveBeenCalled
      expect(window.ErrorFocusModule.focusOnErrorSection.calls.count()).toBe 1
