//= require underscore
//= require jquery
//= require jasmine-jquery
//= require postcode_picker_module



describe 'PostcodePickerModule', ->
  element = null

  beforeEach ->
    element = $(
      '<input type="text" size="8" name="claim[property][postcode]" maxlength="8" id="first_postcode_edit_field" class="smalltext postcode-picker-edit-field">' +
      '<span type="submit" name="FindUkPostcode" id="claim_property_postcode_picker_button" class="button primary postcode-picker-button">Find UK Postcode</span>' 
    )
    $(document.body).append(element)
    
  afterEach ->
    element.remove()
    element = null

  describe 'setup', ->
    it 'should call bindToFindPostcodeButton', ->
      spyOn window.PostcodePickerModule, 'bindToFindPostcodeButton'
      window.PostcodePickerModule.setup()
      expect(window.PostcodePickerModule.bindToFindPostcodeButton).toHaveBeenCalled()
      # expect(1).toBe 2

  describe 'bindToFindPostcodeButton', ->
    it 'should call actionFindPostcodeButton for each postcode-picker-button', ->
      spyOn window.PostcodePickerModule, 'actionFindPostcodeClicked'
      window.PostcodePickerModule.bindToFindPostcodeButton()
      expect(window.PostcodePickerModule.actionFindPostcodeClicked).toHaveBeenCalled()




