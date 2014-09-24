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
        <option value="0">130, Northumberland Avenue, READING</option>
        <option value="1">132, Northumberland Avenue, READING</option>
        <option value="2">134, Northumberland Avenue, READING</option>
        <option value="3">136, Northumberland Avenue, READING</option>
        <option value="4">138, Northumberland Avenue, READING</option>
        <option value="5">140, Northumberland Avenue, READING</option>
        <option value="6">142, Northumberland Avenue, READING</option>
        <option value="7">144, Northumberland Avenue, READING</option>
        <option value="8">146, Northumberland Avenue, READING</option>
        <option value="9">148, Northumberland Avenue, READING</option>
        <option value="12">150, Northumberland Avenue, READING</option>
        <option value="11">152, Northumberland Avenue, READING</option>
        <option value="12">154, Northumberland Avenue, READING</option>
        <option value="13">156, Northumberland Avenue, READING</option>
        <option value="14">158, Northumberland Avenue, READING</option>
        <option value="15">160, Northumberland Avenue, READING</option>
        <option value="16">162, Northumberland Avenue, READING</option>
        <option value="17">164, Northumberland Avenue, READING</option>
        <option value="18">166, Northumberland Avenue, READING</option>
        <option value="19">168, Northumberland Avenue, READING</option>
        <option value="20">170, Northumberland Avenue, READING</option>
        <option value="21">172, Northumberland Avenue, READING</option>
        <option value="22">174, Northumberland Avenue, READING</option>
        <option value="23">176, Northumberland Avenue, READING</option>
        <option value="24">178, Northumberland Avenue, READING</option>
        <option value="25">180, Northumberland Avenue, READING</option>
        <option value="26">182, Northumberland Avenue, READING</option>
        <option value="27">184, Northumberland Avenue, READING</option>
        <option value="28">186, Northumberland Avenue, READING</option>
        <option value="29">188, Northumberland Avenue, READING</option>
        <option value="30">190, Northumberland Avenue, READING</option>
        <option value="31">192, Northumberland Avenue, READING</option>
        <option value="32">194, Northumberland Avenue, READING</option>
        <option value="33">196, Northumberland Avenue, READING</option>
        <option value="36">Flat 1, 200 Northumberland Avenue, READING</option>
        <option value="37">Flat 2, 200 Northumberland Avenue, READING</option>
        <option value="38">Flat 3, 200 Northumberland Avenue, READING</option>
        <option value="39">Flat 4, 200 Northumberland Avenue, READING</option>
        <option value="40">Flat 5, 200 Northumberland Avenue, READING</option>
        <option value="41">Flat 6, 200 Northumberland Avenue, READING</option>
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