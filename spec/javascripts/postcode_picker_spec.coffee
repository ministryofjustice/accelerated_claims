//= require underscore
//= require jquery
//= require jasmine-jquery
//= require postcode_picker
//= require postcode_lookup

describe 'PostcodePicker', ->
  element = null

  beforeEach ->
    element = $("
<head>
</head>
<body class='js-enabled'>
<div class='postcode postcode-picker-container'>
  <div class='postcode-lookup row rel'>
    <label class='postcode-picker-label' for='claim_property_postcode_edit_field'>Postcode</label>
    <input class='smalltext postcode-picker-edit-field' maxlength='8' name='claim[property][postcode]' size='8' type='text'>
    <a class='button primary postcode-picker-button' href='#property_postcode_picker' name='FindUkPostcode'>
      Find UK Postcode
    </a>
    <div class='postcode-picker-hourglass hide'>
      Finding address....
    </div>
    <div class='postcode-select-container hide'>
      <fieldset class='postcode-picker-address-list'>
        <select class='address-picker-select' name='sel-address' size='6' width='50'>
          <option disabled='disabled' value=''>Please select an address</option>
        </select>
        <a class='button primary postcode-picker-cta' href='#' name='SelectAddress'>
          Select Address
        </a>
      </fieldset>
    </div>
  </div>
  <div class='address details extra no sub-panel'>
    <div class='row js-only'>
      <a class='caption postcode-picker-manual-link' href='#claim_property_postcode_picker_manual_link'>
        I want to add an address myself
      </a>
    </div>
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
  </div>
</div>
</body>")

    @results = [
      {"address":"Flat 1;;1 Melbury Close;;FERNDOWN","postcode":"BH22 8HR"},
      {"address":"3 Melbury Close;;FERNDOWN","postcode":"BH22 8HR"}
    ]
    $(document.body).append(element)
    pickerDivs = $('.postcode-picker-container')
    @picker = pickerDivs.eq(0)
    @postcodeEditField = @picker.find('.postcode-picker-edit-field')
    @view = new window.PostcodePicker( @picker )

  afterEach ->
    element.remove()
    element = null

  describe 'enter postcode and find postcode button clicked', ->
    it 'looks up postcode', ->
      spyOn window.PostcodeLookup, 'lookup'

      @postcodeEditField.val('SW106AJ')
      @picker.find('.postcode-picker-button').click()

      expect(window.PostcodeLookup.lookup).toHaveBeenCalledWith('SW106AJ', @view)

  describe 'displayAddresses called with array of addresses', ->

    it 'renders list of addresses in select box', ->
      @view.displayAddresses(@results)
      options = @picker.find('.address-picker-select').find('option')
      expect( options.size() ).toEqual 3

      expect( options.eq(0).text() ).toEqual 'Please select an address'
      expect( options.eq(1).text() ).toEqual 'Flat 1, 1 Melbury Close, FERNDOWN'
      expect( options.eq(2).text() ).toEqual '3 Melbury Close, FERNDOWN'

      expect(@picker.find('.postcode-select-container')).toBeVisible()

    it 'clears the existing contents of the select box before adding in new ones', ->
      @view.displayAddresses(@results)
      @view.displayAddresses(@results)
      options = @picker.find('.address-picker-select').find('option')
      expect( options.size() ).toEqual 3

      expect( options.eq(0).text() ).toEqual 'Please select an address'
      expect( options.eq(1).text() ).toEqual 'Flat 1, 1 Melbury Close, FERNDOWN'
      expect( options.eq(2).text() ).toEqual '3 Melbury Close, FERNDOWN'

      expect(@picker.find('.postcode-select-container')).toBeVisible()

  describe 'invalid postcode', ->
    it 'should display an error message', ->
      @view.displayInvalidPostcodeMessage()
      expect( @picker.find('span.error.postcode').text() ).toEqual 'Please enter a valid UK postcode'

    it 'clears existing error message', ->
      @view.displayInvalidPostcodeMessage()
      @view.displayInvalidPostcodeMessage()
      expect( @picker.find('span.error.postcode').size() ).toEqual 1

    it 'should remove a previously-displayed error message on edit field keyup', ->
      @view.displayInvalidPostcodeMessage()
      @postcodeEditField.trigger('keyup')
      expect( @picker.find('span.error.postcode').size() ).toEqual 0

  describe 'displayNoResultsFound', ->
    it 'should display an error message', ->
      @view.displayNoResultsFound()
      expect( @picker.find('span.error.postcode').text() ).toEqual 'No address found. Please enter the address manually'

    it 'clears existing error message', ->
      @view.displayNoResultsFound()
      @view.displayNoResultsFound()
      expect( @picker.find('span.error.postcode').size() ).toEqual 1

    it 'should remove a previously-displayed error message on edit field keyup', ->
      @view.displayNoResultsFound()
      @postcodeEditField.trigger('keyup')
      expect( @picker.find('span.error.postcode').size() ).toEqual 0

  describe 'service not available', ->
    beforeEach ->
      @view.displayServiceUnavailable()

    it 'should display an error message', ->
      expect( @picker.find('span.error.postcode').size() ).toEqual 1
      expect( @picker.find('span.error.postcode').text() ).toEqual(
        'Postcode lookup service not available. Please enter the address manually.'
      )

    it 'should hide postcode picker', ->
      expect( @picker.find('.postcode-select-container') ).toBeHidden()

  describe 'selecting address from select box', ->
    beforeEach ->
      @view.displayAddresses(@results)
      @picker.find('option').eq(1).attr('selected', 'selected')
      @picker.find('.postcode-picker-cta').click()

    it 'adds open class to address details', ->
      expect( @picker.find( '.address.details' ).hasClass('open') ).toBe(true)

    it 'should populate address street', ->
      expect( @picker.find('.street textarea').val() ).toEqual "Flat 1\n1 Melbury Close\nFERNDOWN"

    it 'should populate address postcode', ->
      expect( @picker.find('.postcode input').val() ).toEqual "BH22 8HR"

    it 'should hide address list', ->
      expect( @picker.find('.postcode-picker-address-list') ).toBeHidden()

    it 'hides manual edit link', ->
      expect( @picker.find('.postcode-picker-manual-link') ).toBeHidden()
