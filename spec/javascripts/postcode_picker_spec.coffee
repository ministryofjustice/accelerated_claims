//= require underscore
//= require jquery
//= require jasmine-jquery
//= require postcode_picker
//= require postcode_lookup

describe 'PostcodePicker', ->
  element = null

  beforeEach ->
    element = $("""
<head>
</head>
<body class='js-enabled'>
<div class="postcode postcode-picker-container" data-vc='england+wales'>
  <div class="row postcode-lookup rel js-only">
    <div class="postcode-display hide" style="margin-bottom: 20px;">
      Postcode:
      <span class="postcode-display-detail" style="font-weight: bold">
        &nbsp;
      </span>
      <span>
        <a class="change-postcode-link2 js-only" href="#change_postcode" id="claim_property-manual_change-link-2" style="display: inline; margin-left: 10px;">Change</a>
      </span>
    </div>
    <div class="postcode-selection-els">
      <label class="postcode-picker-label" for="claim_property_postcode_edit_field">Postcode</label>
      <input class="smalltext postcode-picker-edit-field" id="claim_property_postcode_edit_field" maxlength="8" name="[postcode]" size="8" type="text">
      <a class="button primary postcode-picker-button" href="#claim_property_postcode_picker" data-country='all' name="FindUkPostcode">
        Find UK Address
      </a>
    </div>
    <div class="postcode-picker-hourglass hide">
      Finding address....
    </div>
    <div class="postcode-select-container sub-panel hide" style="margin-top: 0px;">
      <fieldset class="postcode-picker-address-list">
        <label class="hint" for="claim_property_address_select">Please select an address</label>
        <select class="address-picker-select" id="claim_property_address_select" name="sel-address" size="6" width="50">
          <option disabled="disabled" id="listbox-0" role="option" value="">Please select an address</option>
        </select>
        <a class="row button primary postcode-picker-cta" href="#claim_property_postcode_picker_manual_link" id="claim_property_selectaddress" name="SelectAddress" style="margin-bottom: 20px;">
          Select address
        </a>
      </fieldset>
    </div>
  </div>
  <div class="js-only row">
    <a class="caption postcode-picker-manual-link" href="#claim_property_postcode_picker_manual_link" id="claim_property_postcode_picker_manual_link" style="margin-top: 20px;">
      Enter address manually
    </a>
  </div>
  <div class="address extra no sub-panel hide" style="margin-top: 10px;">
    <div class="row street">
      <label for="claim_property_street">
        Full address
      </label>
      <textarea class="street" id="claim_property_street" maxlength="70" name="claim[property][street]"></textarea>
    </div>
    <div class="row js-only">
      <span class="error hide" id="claim_property_street-error-message">
        The address can’t be longer than 4 lines.
      </span>
    </div>
    <div class="row address-postcode">
      <label for="claim_property_postcode">
        Postcode
      </label>
      <br>
      <div style="overflow: hidden; width: 100%">
        <input class="smalltext postcode" id="claim_property_postcode" maxlength="8" name="claim[property][postcode]" size="8" style="float: left;  margin-right: 20px;" type="text" value="">
        <a class="change-postcode-link js-only" href="#change_postcode" style="float: left;">Change</a>
      </div>
    </div>
  </div>
</div>
</body>""")

    @results = {
      'code':     2000,
      'message':  'Success',
      'result':  [
        {
          "address":"Flat 1;;1 Melbury Close;;FERNDOWN",
          "postcode":"BH22 8HR",
          "country": "England"
        },
        {
          "address":"3 Melbury Close;;FERNDOWN",
          "postcode":"BH22 8HR",
          "country": "England"
        }
      ]
    }
    $(document.body).append(element)
    pickerDivs = $('.postcode-picker-container')
    @picker = pickerDivs.eq(0)
    @postcodeEditField = @picker.find('.postcode-picker-edit-field')
    @postcodeSearchComponent = @picker.find('.postcode-selection-els')
    @view = new window.PostcodePicker( @picker )

  afterEach ->
    element.remove()
    element = null

  describe 'enter postcode and find postcode button clicked', ->
    it 'looks up postcode', ->
      spyOn window.PostcodeLookup, 'lookup'

      @postcodeEditField.val('SW106AJ')
      @picker.find('.postcode-picker-button').click()

      expect(window.PostcodeLookup.lookup).toHaveBeenCalledWith('SW106AJ', 'all', @view)

  describe 'handleSuccessfulResponse called with array of addresses', ->
    it 'renders list of addresses in select box', ->
      @view.handleSuccessfulResponse(@results)
      options = @picker.find('.address-picker-select').find('option')
      expect( options.size() ).toEqual 2

      expect( options.eq(0).text() ).toEqual 'Flat 1, 1 Melbury Close, FERNDOWN'
      expect( options.eq(1).text() ).toEqual '3 Melbury Close, FERNDOWN'

      expect(@picker.find('.postcode-select-container').css('display')).toEqual('block')

    it 'clears the existing contents of the select box before adding in new ones', ->
      @view.handleSuccessfulResponse(@results)
      @view.handleSuccessfulResponse(@results)
      options = @picker.find('.address-picker-select').find('option')
      expect( options.size() ).toEqual 2

      expect( options.eq(0).text() ).toEqual 'Flat 1, 1 Melbury Close, FERNDOWN'
      expect( options.eq(1).text() ).toEqual '3 Melbury Close, FERNDOWN'

      expect(@picker.find('.postcode-select-container').css('display')).toEqual('block')

    it 'hides the postcode entry box', ->
      @view.handleSuccessfulResponse(@results)
      expect( @postcodeSearchComponent ).not.toBeVisible()

    it 'displays the selected postcode as fixed text', ->
      @view.handleSuccessfulResponse(@results)
      pcd = @picker.find('.postcode-display')
      expect(pcd.css('display')).toEqual('block')
      expect(@picker.find('.postcode-display-detail').html()).toEqual 'BH22 8HR'

    it 'displays not England and Wales message if code = 4041', ->
      response = { 'code': 4041, 'message': 'Northern Ireland' }
      @view.handleSuccessfulResponse(response)
      expect( @picker.find('span.error.postcode').text() ).toEqual 'Postcode is in Northern Ireland. You can only use this service to regain possession of properties in England and Wales.'

  describe 'invalid postcode', ->
    it 'should display an error message', ->
      @view.displayInvalidPostcodeMessage()
      expect( @picker.find('span.error.postcode').text() ).toEqual 'Please enter a valid postcode in England and Wales'

    it 'clears existing error message', ->
      @view.displayInvalidPostcodeMessage()
      @view.displayInvalidPostcodeMessage()
      expect( @picker.find('span.error.postcode').size() ).toEqual 1

    it 'should remove a previously-displayed error message on edit field keyup', ->
      @view.displayInvalidPostcodeMessage()
      @postcodeEditField.trigger('keyup')
      expect( @picker.find('span.error.postcode').size() ).toEqual 0

  describe 'displayNoResultsFound', ->
    it 'should display an error message if no result found', ->
      response =  {'responseJSON': { "code": 4040, "message": "Postcode Not Found" } }
      @view.displayNoResultsFound(response)
      expect( @picker.find('span.error.postcode').text() ).toEqual 'No address found. Please enter the address manually'

    it 'clears existing error message', ->
      response =  {'responseJSON':  { "code": 4040, "message": "Postcode Not Found" } }
      @view.displayNoResultsFound(response)
      response =  {'responseJSON':  { "code": 4041, "message": "Northern Ireland" } }
      @view.displayNoResultsFound(response)
      expect( @picker.find('span.error.postcode').size() ).toEqual 1

    it 'should remove a previously-displayed error message on edit field keyup', ->
      response =  {'responseJSON':  { "code": 4040, "message": "Postcode Not Found" } }
      @view.displayNoResultsFound(response)
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

  describe 'selecting address from select box', ->
    beforeEach ->
      @view.handleSuccessfulResponse(@results)
      @picker.find('option').eq(0).attr('selected', 'selected')
      @picker.find('.postcode-picker-cta').click()

    it 'populates address street', ->
      expect( @picker.find('.street textarea').val() ).toEqual "Flat 1\n1 Melbury Close\nFERNDOWN"

    it 'populates address postcode', ->
      expect( @picker.find('input.postcode').val() ).toEqual "BH22 8HR"

    it 'hides address list', ->
      expect( @picker.find('.postcode-picker-address-list') ).toBeHidden()

    it 'hides manual edit link', ->
      expect( @picker.find('.postcode-picker-manual-link') ).toBeHidden()

    it 'hides the postcode-disply element', ->
      expect( @picker.find('.postcode-display')).toBeHidden()

    it 'should mark the postcode field as readonly', ->
      expect( @picker.find('#claim_property_postcode')).toHaveAttr('readonly', 'readonly')

  describe 'clicking on change-postcode-link2', ->
    beforeEach ->
      @view.displayServiceUnavailable()

    it 'should hide postcode fixed text', ->
      expect(@picker.find('.postcode-display').css('display')).toEqual('block')
      @picker.find('.change-postcode-link2').trigger('click')
      expect(@picker.find('.postcode-display').hasClass('hide')).toBe true

  describe 'displaying results after selection', ->
    beforeEach ->
      @view.handleSuccessfulResponse(@results)
      @picker.find('option').eq(1).attr('selected', 'selected')
      @picker.find('.postcode-picker-cta').click()
      @view.handleSuccessfulResponse(@results)

    it 'shows address list', ->
      expect(@picker.find('.postcode-select-container').css('display')).toEqual('block')

  describe 'toSentence', ->
    it 'should return just the name of a country if only one in the array', ->
      expect(@view.toSentence(['England'])).toEqual 'England'

    it 'should separate a two element array by and', ->
      expect(@view.toSentence(['England', 'Wales'])).toEqual 'England and Wales'

    it 'should separate a list by commas and the last by and', ->
      expect(@view.toSentence(['England', 'Wales', 'Northern Ireland'])).toEqual 'England, Wales and Northern Ireland'

  describe 'capitalizeCountry', ->
    it 'should capitalize single work country names', ->
      expect(@view.capitalizeCountry('england')).toEqual 'England'

    it 'should capitalize multi-workd country names', ->
      expect(@view.capitalizeCountry('northern_ireland')).toEqual 'Northern Ireland'

    it 'should lowercase of in country names', ->
      expect(@view.capitalizeCountry('isle_of_man')).toEqual 'Isle of Man'

  describe 'normalizeCountry', ->
    it 'should return uk for all', ->
      vc = @picker.data('vc')
      expect(@view.normalizeCountry('all')).toEqual 'UK'

    it 'should return England and Wales for england+wales', ->
      expect(@view.normalizeCountry('england+wales')).toEqual 'England and Wales'

    it 'should return England, Wales, Channel Islands, Northern Ireland and Isle of Man', ->
      expect(@view.normalizeCountry('england+wales+channel_islands+northern_ireland+isle_of_man')).toEqual 'England, Wales, Channel Islands, Northern Ireland and Isle of Man'
