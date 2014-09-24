//= require underscore
//= require jquery
//= require jasmine-jquery
//= require postcode_picker
//= require postcode_lookup

describe 'PostcodePicker', ->
  element = null

  beforeEach ->
    element = $(
      '<div class="row rel postcode postcode-picker-container">
      <input 
        type="text"
        size="8"
        name="claim[property][postcode]"
        maxlength="8"
        id="claim_property_postcode_edit_field"
        class="smalltext postcode-picker-edit-field">
      <span
        type="submit"
        name="FindUkPostcode"
        id="claim_property_postcode_picker_button"
        class="button primary postcode-picker-button">
          Find UK Postcode
        </span>
      </div>' 
    )
    @results = [{"address":"1 Melbury Close;;FERNDOWN","postcode":"BH22 8HR"},{"address":"3 Melbury Close;;FERNDOWN","postcode":"BH22 8HR"}]

    $(document.body).append(element)
    @picker = $( $('.postcode-picker-container')[0] )
    
  afterEach ->
    element.remove()
    element = null

  describe 'enter postcode and find postcode button clicked', ->
    it 'looks up postcode', ->
      spyOn window.PostcodeLookup, 'lookup'

      @picker.find('.postcode-picker-edit-field').val('SW106AJ')
      
      view = new window.PostcodePicker( @picker )
      @picker.find('.postcode-picker-button').click()

      expect(window.PostcodeLookup.lookup).toHaveBeenCalledWith('SW106AJ', view)

  describe 'displayAddresses called with array of addresses', ->
    it 'renders list of addresses in select box', ->
      @picker