//= require underscore
//= require jquery
//= require jasmine-jquery
//= require postcode_picker
//= require postcode_lookup

describe 'PostcodePicker', ->
  element = null

  beforeEach ->
    element = $('<div class="row rel postcode postcode-picker-container" id="property_postcode_picker">
  <label for="claim_property_postcode_edit_field" class="postcode-picker-label">Postcode</label>
  <input class="smalltext postcode-picker-edit-field" id="claim_property_postcode_edit_field" maxlength="8" name="claim[property][postcode]" size="8" type="text">
  <span class="button primary postcode-picker-button" id="claim_property_postcode_picker_button" name="FindUkPostcode" type="submit"> 
    Find UK Postcode
  </span>
  <a class="caption postcode-picker-manual-link" href="#claim_property_postcode_picker_manual_link" id="claim_property_postcode_picker_manual_link">
    I want to add an address myself
  </a>

<div id="claim_property_postcode_hourglass" class="postcode-picker-hourglass hide">
  Finding address....
</div>

<div id="property_postcode_select_container" class="property-postcode-select-container hide">
  <div id="property-postcode-reveal" class="postcode-picker-display_container">
    <label for="claim_property_postcode_display" class="postcode-picker-label">Postcode</label>
    <span class="postcode-picker-display">N4 4EB</span>
    <a class="caption postcode-picker-change-link" href="#property_postcode_change">Change</a>
  </div>


  <div id="claim-property-postcode-picker-address-list">
    <fieldset id="property-address-picker" class="postcode-picker-address-list">
      <select size="6" name="sel-address" id="sel-address" class="address-picker-select" width="50">
        <option disabled="disabled" value="">Please select an address</option>
        
      </select>
    </fieldset>
  </div>
  <input class="button primary postcode-picker-cta" id="select-address" name="SelectAddress" type="submit" value="Select Address">
</div>

<div class="address extra hide no sub-panel">
  <div class="row rel street">
    <label for="claim_property_street">Full address</label>
    <textarea id="claim_property_street" maxlength="70" name="claim[property][street]"></textarea>
  </div>
  <div class="row js-only">
    <span class="error hide" id="claim_property_street-error-message">
      The address can’t be longer than 4 lines.
    </span>
  </div>
  <div class="row rel postcode">
    <label for="claim_defendant_1_postcode">Postcode</label>
    <input class="smalltext" id="claim_property_postcode hide" maxlength="8" name="claim[defendant_1][postcode]" size="8" type="text">
  </div>
</div>')
    @results = [
      {"address":"Flat 1;;1 Melbury Close;;FERNDOWN","postcode":"BH22 8HR"},
      {"address":"3 Melbury Close;;FERNDOWN","postcode":"BH22 8HR"}
    ]

    $(document.body).append(element)
    pickerDivs = $('.postcode-picker-container')
    @pickerDiv = pickerDivs.eq(0)
    @view = new window.PostcodePicker( @pickerDiv )
    
  afterEach ->
    element.remove()
    element = null

  describe 'enter postcode and find postcode button clicked', ->
    it 'looks up postcode', ->
      spyOn window.PostcodeLookup, 'lookup'

      @pickerDiv.find('.postcode-picker-edit-field').val('SW106AJ')      
      @pickerDiv.find('.postcode-picker-button').click()

      expect(window.PostcodeLookup.lookup).toHaveBeenCalledWith('SW106AJ', @view)

  describe 'displayAddresses called with array of addresses', ->

    it 'renders list of addresses in select box', ->
      @view.displayAddresses(@results)
      options = @pickerDiv.find('.address-picker-select').find('option')
      expect( options.size() ).toEqual 3
      
      expect( options.eq(0).text() ).toEqual 'Please select an address'
      expect( options.eq(1).text() ).toEqual 'Flat 1, 1 Melbury Close, FERNDOWN'
      expect( options.eq(2).text() ).toEqual '3 Melbury Close, FERNDOWN'

      expect(@pickerDiv.find('.property-postcode-select-container').hasClass('hide') ).toBe(false)
      
    it 'clears the existing contents of the select box before adding in new ones', ->
      @view.displayAddresses(@results)
      @view.displayAddresses(@results)
      options = @pickerDiv.find('.address-picker-select').find('option')
      expect( options.size() ).toEqual 3
      
      expect( options.eq(0).text() ).toEqual 'Please select an address'
      expect( options.eq(1).text() ).toEqual 'Flat 1, 1 Melbury Close, FERNDOWN'
      expect( options.eq(2).text() ).toEqual '3 Melbury Close, FERNDOWN'

      expect(@pickerDiv.find('.property-postcode-select-container').hasClass('hide') ).toBe(false)
      







