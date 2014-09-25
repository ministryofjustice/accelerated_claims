//= require underscore
//= require jquery
//= require jasmine-jquery
//= require postcode_picker
//= require postcode_lookup

describe 'PostcodePicker', ->
  element = null

  beforeEach ->
    element = $("
<div class='row rel postcode postcode-picker-container'>
  <div class='postcode-lookup'>
    <label class='postcode-picker-label' for='claim_property_postcode_edit_field'>Postcode</label>
    <input class='smalltext postcode-picker-edit-field' id='claim_property_postcode_edit_field' maxlength='8' name='claim[property][postcode]' size='8' type='text'>
    <a class='button primary postcode-picker-button' href='#property_postcode_picker' id='claim_property_postcode_picker_button' name='FindUkPostcode'>
      Find UK Postcode
    </a>
    <a class='caption postcode-picker-manual-link' href='#claim_property_postcode_picker_manual_link' id='claim_property_postcode_picker_manual_link'>
      I want to add an address myself
    </a>
    <div class='postcode-picker-hourglass hide' id='claim_property_postcode_hourglass'>
      Finding address....
    </div>
    <div class='postcode-select-container hide' id='property_postcode_select_container'>
      <div class='postcode-picker-display_container' id='property-postcode-reveal'>
        <label class='postcode-picker-label' for='claim_property_postcode_display'>Postcode</label>
        <span class='postcode-picker-display'>N4 4EB</span>
        <a class='caption postcode-picker-change-link' href='#property_postcode_change'>Change</a>
      </div>
      <div id='claim-property-postcode-picker-address-list'>
        <fieldset class='postcode-picker-address-list' id='property-address-picker'>
          <select class='address-picker-select' id='sel-address' name='sel-address' size='6' width='50'>
            <option disabled='disabled' value=''>Please select an address</option>
          </select>
        </fieldset>
      </div>
      <input class='button primary postcode-picker-cta' id='select-address' name='SelectAddress' type='submit' value='Select Address'>
    </div>
  </div>
</div>
<div class='address extra no sub-panel hide'>
  <div class='row rel street'>
    <label for='claim_property_street'>Full address</label>
    <textarea id='claim_property_street' maxlength='70' name='claim[property][street]'></textarea>
  </div>
  <div class='row js-only'>
    <span class='error hide' id='claim_property_street-error-message'>
      The address can’t be longer than 4 lines.
    </span>
  </div>
  <div class='row rel postcode'>
    <label for='claim_defendant_1_postcode'>Postcode</label>
    <input class='smalltext' id='claim_property_postcode hide' maxlength='8' name='claim[defendant_1][postcode]' size='8' type='text'>
  </div>
</div>")

    @results = [
      {"address":"Flat 1;;1 Melbury Close;;FERNDOWN","postcode":"BH22 8HR"},
      {"address":"3 Melbury Close;;FERNDOWN","postcode":"BH22 8HR"}
    ]
    $(document.body).append(element)
    pickerDivs = $('.postcode-picker-container')
    @pickerDiv = pickerDivs.eq(0)
    @postcodeEditField = @pickerDiv.find('.postcode-picker-edit-field')
    @view = new window.PostcodePicker( @pickerDiv )
    
  afterEach ->
    element.remove()
    element = null

  describe 'enter postcode and find postcode button clicked', ->
    it 'looks up postcode', ->
      spyOn window.PostcodeLookup, 'lookup'

      @postcodeEditField.val('SW106AJ')      
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

      expect(@pickerDiv.find('.postcode-select-container')).toBeVisible()
      
    it 'clears the existing contents of the select box before adding in new ones', ->
      @view.displayAddresses(@results)
      @view.displayAddresses(@results)
      options = @pickerDiv.find('.address-picker-select').find('option')
      expect( options.size() ).toEqual 3
      
      expect( options.eq(0).text() ).toEqual 'Please select an address'
      expect( options.eq(1).text() ).toEqual 'Flat 1, 1 Melbury Close, FERNDOWN'
      expect( options.eq(2).text() ).toEqual '3 Melbury Close, FERNDOWN'

      expect(@pickerDiv.find('.postcode-select-container')).toBeVisible()

  describe 'invalid postcode', ->
    it 'should display an error message', ->
      @view.displayInvalidPostcodeMessage() 
      expect( @pickerDiv.find('span.error.postcode').text() ).toEqual 'That is an invalid postcode!'    

    it 'clears existing error message', ->
      @view.displayInvalidPostcodeMessage() 
      @view.displayInvalidPostcodeMessage() 
      expect( @pickerDiv.find('span.error.postcode').size() ).toEqual 1

    it 'should remove a previously-displayed error message on edit field keyup', ->
      @view.displayInvalidPostcodeMessage() 
      @postcodeEditField.trigger('keyup')
      expect( @pickerDiv.find('span.error.postcode').size() ).toEqual 0

  describe 'displayNoResultsFound', ->
    it 'should display an error message', ->
      @view.displayNoResultsFound() 
      expect( @pickerDiv.find('span.error.postcode').text() ).toEqual 'No addresses for that postcode!'    

    it 'clears existing error message', ->
      @view.displayNoResultsFound() 
      @view.displayNoResultsFound() 
      expect( @pickerDiv.find('span.error.postcode').size() ).toEqual 1

    it 'should remove a previously-displayed error message on edit field keyup', ->
      @view.displayNoResultsFound() 
      @postcodeEditField.trigger('keyup')
      expect( @pickerDiv.find('span.error.postcode').size() ).toEqual 0

  describe 'clicking add address manually link', ->
    it 'should hide postcode picker', ->
      @pickerDiv.find('.postcode-picker-manual-link').click()
      expect( @pickerDiv.find('.postcode-select-container').hasClass('hide') ).toBe(true)

    # it 'should display address box', ->
    #   @pickerDiv.find('.postcode-picker-manual-link').click()
    #   expect( @pickerDiv.find('.address').hasClass('hide') ).toBe(false)



