//= require underscore
//= require jquery
//= require jasmine-jquery
//= require postcode_picker
//= require postcode_lookup

describe 'PostcodePicker', ->
  element = null

  beforeEach ->
    element = $(
      '<input 
        type="text"
        size="8"
        name="claim[property][postcode]"
        maxlength="8"
        id="first_postcode_edit_field"
        class="smalltext postcode-picker-edit-field">
      <span
        type="submit"
        name="FindUkPostcode"
        id="claim_property_postcode_picker_button"
        class="button primary postcode-picker-button">
          Find UK Postcode
        </span>' 
    )
    $(document.body).append(element)
    
  afterEach ->
    element.remove()
    element = null

  describe 'find postcode button clicked', ->
    it 'looks up postcode', ->
      spyOn window.PostcodeLookup, 'lookup'
      
      button = $('#claim_property_postcode_picker_button')
      new window.PostcodePicker( button )
      button.click()

      expect(window.PostcodeLookup.lookup).toHaveBeenCalled()
