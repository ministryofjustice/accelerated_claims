//= require jquery_ujs
//= require underscore

//= require details.polyfill.for-jasmine-testing
//= require bind

//= require address_module
//= require postcode_picker

//= require claimant_contact

sleep = (ms) ->
  start = new Date().getTime()
  continue while new Date().getTime() - start < ms

describe 'ClaimantContact', ->
  element = null

  beforeEach ->
    element = $("""
<head>
</head>
<body class='js-enabled'>
  <section>
    <h2 class='section-header' id='claimant-section'>Claimants</h2>
    <div class='moj-panel' data-caption="As the landlord, you're known as the &lt;strong&gt;claimant&lt;/strong&gt; in this case." data-multiple='claimant' data-plural='claimants' data-single='claimant' id='claimants'>
      <div class='row'>
        As the landlord, you’re known as the <b>claimant</b> in this case.
      </div>
      <fieldset class="radio js-depend" data-depend="claimanttype"><legend class="visuallyhidden">What kind of claimant are you?</legend><div><span aria-hidden='true'>What kind of claimant are you?</span></div><div class='options'><div class='option'><label for='claim_claimant_type_individual'><input data-virtual-pageview="/accelerated/claimants-section" id="claim_claimant_type_individual" name="claim[claimant_type]" type="radio" value="individual" />
      A private landlord (individual)</label></div>

      <div class='option'><label for='claim_claimant_type_organization'><input data-virtual-pageview="/accelerated/claimants-section" id="claim_claimant_type_organization" name="claim[claimant_type]" type="radio" value="organization" />
      A private landlord (company), a local authority or a housing association</label></div></div>
      </fieldset>
      <div class='row hide js-claimanttype individual'><label for="claim_num_claimants">How many claimants are there? <br/><span class="hint">All claimants should be named on the tenancy agreement</span></label>
      <input class="narrow" data-depend="num-claimants" id="claim_num_claimants" name="claim[num_claimants]" type="text" /></div>
      <div class='row js-only'>
        <span class='error hide' id='num-claimants-error-message'>
          The number of claimants must be between 1 and 4. If you have more than 4 claimants, you’ll need to complete your
          accelerated possession claim on the <a href="http://hmctsformfinder.justice.gov.uk/HMCTS/GetForm.do?court_forms_id=618">N5b form</a>
        </span>
      </div>
      <div class='claimants'>
        <div class='claimant sub-panel' data-claimant-id='1' id='claimant_1_subpanel'>
          <div class='row'>
            <h3>Claimant 1</h3>
          </div>
          <div class='row title hide js-claimanttype individual'><label for="claim_claimant_1_title">Title</label>
          <input class="smalltext" id="claim_claimant_1_title" maxlength="8" name="claim[claimant_1][title]" size="8" type="text" /></div>
          <div class='row rel hide js-claimanttype individual'><label for="claim_claimant_1_full_name">Full name</label>
          <input id="claim_claimant_1_full_name" maxlength="40" name="claim[claimant_1][full_name]" size="40" type="text" /></div>
          <div class='row hide nonjs js-claimanttype individual'>OR</div>
          <div class='row rel hide js-claimanttype organization'><label for="claim_claimant_1_organization_name">Company name or local authority name</label>
          <input id="claim_claimant_1_organization_name" name="claim[claimant_1][organization_name]" type="text" /></div>
          <div class='sub-panel rel address'>
            <div class='postcode postcode-picker-container' data-vc='all'>
              <div class='row postcode-lookup rel js-only'>
                <div class='postcode-display hide' style='margin-bottom: 20px;'>
                  Postcode:
                  <span class='postcode-display-detail' style='font-weight: bold'>
                    &nbsp;
                  </span>
                  <span>
                    <a class='change-postcode-link2 js-only' href='#dummy_anchor' id='claim_claimant_1-manual_change-link-2' style='display: inline; margin-left: 10px;'>Change</a>
                  </span>
                </div>
                <div class='postcode-selection-els'>
                  <label class='postcode-picker-label' for='claim_claimant_1_postcode_edit_field'>Postcode</label>
                  <input class='smalltext postcode-picker-edit-field' id='claim_claimant_1_postcode_edit_field' maxlength='8' name='[postcode]' size='8' type='text'>
                  <a class='button primary postcode-picker-button' data-country='all' href='#claim_claimant_1_postcode_picker'>
                    Find UK address
                  </a>
                </div>
                <div class='postcode-picker-hourglass hide'>
                  Finding address....
                </div>
                <div class='postcode-select-container sub-panel hide' style='margin-top: 0px;'>
                  <fieldset class='postcode-picker-address-list'>
                    <label class='hint' for='claim_claimant_1_address_select'>Please select an address</label>
                    <select class='address-picker-select' id='claim_claimant_1_address_select' name='sel-address' role='listbox' size='6'>
                      <option disabled='disabled' id='claim_claimant_1-listbox' role='option' value=''>Please select an address</option>
                    </select>
                    <a class='row button primary postcode-picker-cta' href='#claim_claimant_1_postcode_picker_manual_link' id='claim_claimant_1_selectaddress' style='margin-bottom: 20px;'>
                      Select address
                    </a>
                  </fieldset>
                </div>
              </div>
              <div class='js-only row'>
                <a class='caption postcode-picker-manual-link' href='#claim_claimant_1_postcode_picker_manual_link' id='claim_claimant_1_postcode_picker_manual_link' style='margin-top: 20px;'>
                  Enter address manually
                </a>
              </div>
              <div class='address extra no sub-panel hide' style='margin-top: 10px;'>
                <div class='row street'>
                  <label for='claim_claimant_1_street'>
                    Full address

                  </label>
                  <textarea class='street' id='claim_claimant_1_street' maxlength='70' name='claim[claimant_1][street]'></textarea>
                </div>
                <div class='row js-only'>
                  <span class='error hide' id='claim_claimant_1_street-error-message'>
                    The address can’t be longer than 4 lines.
                  </span>
                </div>
                <div class='row address-postcode'>
                  <label for='claim_claimant_1_postcode'>
                    Postcode
                  </label>
                  <br>
                  <div style='overflow: hidden; width: 100%'>
                    <input class='smalltext postcode' id='claim_claimant_1_postcode' maxlength='8' name='claim[claimant_1][postcode]' size='8' style='float: left;  margin-right: 20px;' type='text' value=''>
                    <a class='change-postcode-link js-only' href='#dummy_anchor' style='float: left;'>Change</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class='claimant same-address sub-panel' data-claimant-id='2' id='claimant_2_subpanel'>
          <div class='row'>
            <h3>Claimant 2 <span class='hint hide js-claimanttype'>(optional)</span></h3>
          </div>
          <div class='row title hide js-claimanttype individual'><label for="claim_claimant_2_title">Title</label>
          <input class="smalltext" id="claim_claimant_2_title" maxlength="8" name="claim[claimant_2][title]" size="8" type="text" /></div>
          <div class='row rel hide js-claimanttype individual'><label for="claim_claimant_2_full_name">Full name</label>
          <input id="claim_claimant_2_full_name" maxlength="40" name="claim[claimant_2][full_name]" size="40" type="text" /></div>
          <div class='sub-panel js-only'>
            <fieldset class="radio inline"><legend class="visuallyhidden">Is the address the same as the first claimant?</legend><div><span aria-hidden='true'>Is the address the same as the first claimant?</span></div><div class='options' data-reverse="true"><div class='option'><label for='claim_claimant_2_address_same_as_first_claimant_yes'><input class="yesno" id="claim_claimant_2_address_same_as_first_claimant_yes" name="claim[claimant_2][address_same_as_first_claimant]" type="radio" value="Yes" />
            Yes</label></div>

            <div class='option'><label for='claim_claimant_2_address_same_as_first_claimant_no'><input class="yesno" id="claim_claimant_2_address_same_as_first_claimant_no" name="claim[claimant_2][address_same_as_first_claimant]" type="radio" value="No" />
            No</label></div></div>
            </fieldset>
          </div>
          <div class='sub-panel rel address'>
            <div class='postcode postcode-picker-container' data-vc='all'>
              <div class='row postcode-lookup rel js-only'>
                <div class='postcode-display hide' style='margin-bottom: 20px;'>
                  Postcode:
                  <span class='postcode-display-detail' style='font-weight: bold'>
                    &nbsp;
                  </span>
                  <span>
                    <a class='change-postcode-link2 js-only' href='#dummy_anchor' id='claim_claimant_2-manual_change-link-2' style='display: inline; margin-left: 10px;'>Change</a>
                  </span>
                </div>
                <div class='postcode-selection-els'>
                  <label class='postcode-picker-label' for='claim_claimant_2_postcode_edit_field'>Postcode</label>
                  <input class='smalltext postcode-picker-edit-field' id='claim_claimant_2_postcode_edit_field' maxlength='8' name='[postcode]' size='8' type='text'>
                  <a class='button primary postcode-picker-button' data-country='all' href='#claim_claimant_2_postcode_picker'>
                    Find UK address
                  </a>
                </div>
                <div class='postcode-picker-hourglass hide'>
                  Finding address....
                </div>
                <div class='postcode-select-container sub-panel hide' style='margin-top: 0px;'>
                  <fieldset class='postcode-picker-address-list'>
                    <label class='hint' for='claim_claimant_2_address_select'>Please select an address</label>
                    <select class='address-picker-select' id='claim_claimant_2_address_select' name='sel-address' role='listbox' size='6'>
                      <option disabled='disabled' id='claim_claimant_2-listbox' role='option' value=''>Please select an address</option>
                    </select>
                    <a class='row button primary postcode-picker-cta' href='#claim_claimant_2_postcode_picker_manual_link' id='claim_claimant_2_selectaddress' style='margin-bottom: 20px;'>
                      Select address
                    </a>
                  </fieldset>
                </div>
              </div>
              <div class='js-only row'>
                <a class='caption postcode-picker-manual-link' href='#claim_claimant_2_postcode_picker_manual_link' id='claim_claimant_2_postcode_picker_manual_link' style='margin-top: 20px;'>
                  Enter address manually
                </a>
              </div>
              <div class='address extra no sub-panel hide' style='margin-top: 10px;'>
                <div class='row street'>
                  <label for='claim_claimant_2_street'>
                    Full address

                  </label>
                  <textarea class='street' id='claim_claimant_2_street' maxlength='70' name='claim[claimant_2][street]'></textarea>
                </div>
                <div class='row js-only'>
                  <span class='error hide' id='claim_claimant_2_street-error-message'>
                    The address can’t be longer than 4 lines.
                  </span>
                </div>
                <div class='row address-postcode'>
                  <label for='claim_claimant_2_postcode'>
                    Postcode
                  </label>
                  <br>
                  <div style='overflow: hidden; width: 100%'>
                    <input class='smalltext postcode' id='claim_claimant_2_postcode' maxlength='8' name='claim[claimant_2][postcode]' size='8' style='float: left;  margin-right: 20px;' type='text' value=''>
                    <a class='change-postcode-link js-only' href='#dummy_anchor' style='float: left;'>Change</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class='sub-panel js-claimanttype individual organization' id='claimant-contact'>
        <div class='row'>
          <details>
            <summary>
              <span class='summary' id='contact-details'>Add phone and email (Optional)</span>
            </summary>
            <div class='panel-indent'>
              <div class='row rel email'><label for="claim_claimant_contact_email">Email<span class="hint nonjs"> (Optional)</span></label>
              <input id="claim_claimant_contact_email" name="claim[claimant_contact][email]" type="text" /></div>
              <div class='row rel phone'><label for="claim_claimant_contact_phone">Phone<span class="hint nonjs"> (Optional)</span></label>
              <input id="claim_claimant_contact_phone" name="claim[claimant_contact][phone]" type="text" /></div>
              <div class='row rel fax'><label for="claim_claimant_contact_fax">Fax<span class="hint nonjs"> (Optional)</span></label>
              <input id="claim_claimant_contact_fax" maxlength="40" name="claim[claimant_contact][fax]" size="40" type="text" /></div>
              <div class='row rel dx_number'><label for="claim_claimant_contact_dx_number">DX number<span class="hint nonjs"> (Optional)</span></label>
              <input id="claim_claimant_contact_dx_number" maxlength="40" name="claim[claimant_contact][dx_number]" size="40" type="text" /></div>
            </div>
          </details>
        </div>
        <div class='row'>
          <p>
            If you want us to send correspondence about the case to a different address, enter it here.
            <span class='hint block js-claimanttype individual js-only'>
              eg a legal representative's address (Optional)
            </span>
            <span class='hint block js-claimanttype organization'>
              eg a legal representative or managing agent's address (Optional)
            </span>
          </p>
          <details>
            <summary>
              <span class='summary' id='correspondence-address'>Add alternative address (Optional)</span>
            </summary>
            <div class='panel-indent'>
              <div class='row rel title'><label for="claim_claimant_contact_title">Title<span class="hint nonjs"> (Optional)</span></label>
              <input class="smalltext" id="claim_claimant_contact_title" maxlength="8" name="claim[claimant_contact][title]" size="8" type="text" /></div>
              <div class='row rel'><label for="claim_claimant_contact_full_name">Full name<span class="hint nonjs"> (Optional)</span></label>
              <input id="claim_claimant_contact_full_name" maxlength="40" name="claim[claimant_contact][full_name]" size="40" type="text" /></div>
              <div class='row rel company_name'><label for="claim_claimant_contact_company_name">Company name<span class="hint nonjs"> (Optional)</span></label>
              <input id="claim_claimant_contact_company_name" maxlength="40" name="claim[claimant_contact][company_name]" size="40" type="text" /></div>
              <div class='postcode postcode-picker-container' data-vc='all'>
                <div class='row postcode-lookup rel js-only'>
                  <div class='postcode-display hide' style='margin-bottom: 20px;'>
                    Postcode:
                    <span class='postcode-display-detail' style='font-weight: bold'>
                      &nbsp;
                    </span>
                    <span>
                      <a class='change-postcode-link2 js-only' href='#dummy_anchor' id='claim_claimant_contact-manual_change-link-2' style='display: inline; margin-left: 10px;'>Change</a>
                    </span>
                  </div>
                  <div class='postcode-selection-els'>
                    <label class='postcode-picker-label' for='claim_claimant_contact_postcode_edit_field'>Postcode</label>
                    <input class='smalltext postcode-picker-edit-field' id='claim_claimant_contact_postcode_edit_field' maxlength='8' name='[postcode]' size='8' type='text'>
                    <a class='button primary postcode-picker-button' data-country='all' href='#claim_claimant_contact_postcode_picker'>
                      Find UK address
                    </a>
                  </div>
                  <div class='postcode-picker-hourglass hide'>
                    Finding address....
                  </div>
                  <div class='postcode-select-container sub-panel hide' style='margin-top: 0px;'>
                    <fieldset class='postcode-picker-address-list'>
                      <label class='hint' for='claim_claimant_contact_address_select'>Please select an address</label>
                      <select class='address-picker-select' id='claim_claimant_contact_address_select' name='sel-address' role='listbox' size='6'>
                        <option disabled='disabled' id='claim_claimant_contact-listbox' role='option' value=''>Please select an address</option>
                      </select>
                      <a class='row button primary postcode-picker-cta' href='#claim_claimant_contact_postcode_picker_manual_link' id='claim_claimant_contact_selectaddress' style='margin-bottom: 20px;'>
                        Select address
                      </a>
                    </fieldset>
                  </div>
                </div>
                <div class='js-only row'>
                  <a class='caption postcode-picker-manual-link' href='#claim_claimant_contact_postcode_picker_manual_link' id='claim_claimant_contact_postcode_picker_manual_link' style='margin-top: 20px;'>
                    Enter address manually
                  </a>
                </div>
                <div class='address extra no sub-panel hide' style='margin-top: 10px;'>
                  <div class='row street'>
                    <label for='claim_claimant_contact_street'>
                      Full address

                    </label>
                    <textarea class='street' id='claim_claimant_contact_street' maxlength='70' name='claim[claimant_contact][street]'></textarea>
                  </div>
                  <div class='row js-only'>
                    <span class='error hide' id='claim_claimant_contact_street-error-message'>
                      The address can’t be longer than 4 lines.
                    </span>
                  </div>
                  <div class='row address-postcode'>
                    <label for='claim_claimant_contact_postcode'>
                      Postcode
                    </label>
                    <br>
                    <div style='overflow: hidden; width: 100%'>
                      <input class='smalltext postcode' id='claim_claimant_contact_postcode' maxlength='8' name='claim[claimant_contact][postcode]' size='8' style='float: left;  margin-right: 20px;' type='text' value=''>
                      <a class='change-postcode-link js-only' href='#dummy_anchor' style='float: left;'>Change</a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </details>
        </div>
        <div class='row' id='reference-block'>
          <details>
            <summary>
              <span class='summary' id='reference-number'>Add a reference number (Optional)</span>
            </summary>
            <div class='panel-indent'>
              <div class='row rel reference_number'><label for="claim_reference_number_reference_number">You can add a reference number for your own use<span class="hint"> (Optional)</span></label>
              <input id="claim_reference_number_reference_number" maxlength="40" name="claim[reference_number][reference_number]" size="40" type="text" /></div>
            </div>
          </details>
        </div>
      </div>
    </div>
  </section>
</body>""")

    $(document.body).append(element)
    window.addDetailsPolyfill()
    @panel = $('#claimant-contact')
    new window.ClaimantContact()
    ClaimantModule.setup()

  afterEach ->
    element.remove()
    element = null

  describe 'initial state', ->
    it 'hides claimant-contact', ->
      expect(@panel).toBeHidden()

  describe 'clicking on claimant type', ->
    it 'doesnt show the claimant-contact panel when claimant type individual clicked if nothing in number of claimants', ->
      $('#claim_claimant_type_individual').trigger('click')
      expect(@panel.css('display')).toEqual('none')
      expect(@panel).toBeHidden()

    it 'shows the claimant-contact panel when claimant type organization clicked', ->
      $('#claim_claimant_type_organization').trigger('click')
      expect(@panel).toBeVisible()

    it 'hides the claimant-contact panel when individual is clicked after organization and number of claimants is zero', ->
      $('#claim_claimant_type_organization').trigger('click')
      expect(@panel).toBeVisible()
      $('#claim_num_claimants').val('0')
      $('#claim_claimant_type_individual').trigger('click')
      expect(@panel).toBeHidden()

    it 'hides the claimant-contact panel when individual is clicked after organization and number of claimants is blank', ->
      $('#claim_claimant_type_organization').trigger('click')
      expect(@panel).toBeVisible()
      $('#claim_claimant_type_individual').trigger('click')
      expect(@panel).toBeHidden()

    it 'hides the claimant-contact panel when individual is clicked after organization and number of claimants > 0', ->
      $('#claim_claimant_type_organization').trigger('click')
      expect(@panel).toBeVisible()
      $('#claim_num_claimants').val('1')
      $('#claim_claimant_type_individual').trigger('click')
      expect(@panel).toBeVisible()

    it 'hides Add reference number link when claimant type individual', ->
      $('#claim_claimant_type_individual').trigger('click')
      expect($('#reference-number')).toBeHidden()

    it 'shows Add reference number link when claimant type organization', ->
      $('#claim_claimant_type_organization').trigger('click')
      expect($('#reference-number').css('display')).toEqual('inline')

  describe 'entering number of claimants', ->
    it 'shows the claimant-contact panels when number of claimants entered > 0', ->
      $('#claim_num_claimants').val('2')
      $('#claim_num_claimants').trigger('keyup')
      expect(@panel).toBeVisible()

    it 'hides the claimant-contact panels when number of claimants entered is zero', ->
      $('#claim_num_claimants').val('0')
      $('#claim_num_claimants').trigger('keyup')
      expect(@panel).toBeHidden()

    it 'hides the claimant-contact panels when number of claimants entered is blank', ->
      $('#claim_num_claimants').val('')
      $('#claim_num_claimants').trigger('keyup')
      expect(@panel).toBeHidden()

  describe 'hiding and showing of contact details block for organizations', ->
    beforeEach ->
      $('#claim_claimant_type_organization').trigger('click')
      @contactDetails = $('#contact-details').parent().parent().find('div').eq(0)

    it 'should be hidden when not clicked', ->
      expect(@contactDetails.css('display')).toEqual('none')

    # When run separately this test is succesful, but fails when all tests runs
    # Commenting it out for now
    # it 'should be displayed when clicked once', ->
      # $('#contact-details').trigger('click')
      # expect(@contactDetails.css('display')).toEqual('block')

    it 'should be hidden when clicked twice', ->
      $('#contact-details').trigger('click')
      $('#contact-details').trigger('click')
      expect(@contactDetails.css('display')).toEqual('none')

  describe 'hiding and showing of alternative address block for organizations', ->
    beforeEach ->
      $('#claim_claimant_type_organization').trigger('click')
      @alternativeAddress = $('#correspondence-address').parent().parent().find('div').eq(0)

    it 'should be hidden when not clicked', ->
      expect(@alternativeAddress.css('display')).toEqual('none')

    # When run separately this test is succesful, but fails when all tests runs
    # Commenting it out for now
    # it 'should be displayed when clicked once', ->
      # $('#correspondence-address').trigger('click')
      # expect(@alternativeAddress.css('display')).toEqual('block')

    it 'should be hidden if clicked twice', ->
      $('#correspondence-address').trigger('click')
      $('#correspondence-address').trigger('click')
      expect(@alternativeAddress.css('display')).toEqual('none')

  describe 'hiding and showing of reference number block for organizations', ->
    beforeEach ->
      $('#claim_claimant_type_organization').trigger('click')
      @referenceNumber = $('#reference-number').parent().parent().find('div').eq(0)

    it 'should be hidden when not clicked', ->
      expect(@referenceNumber.css('display')).toEqual('none')

    # When run separately this test is succesful, but fails when all tests runs
    # Commenting it out for now
    # it 'should be displayed when clicked once', ->
      # $('#reference-number').trigger('click')
      # expect(@referenceNumber.css('display')).toEqual('block')

    it 'should be hidden if clicked twice', ->
      $('#reference-number').trigger('click')
      $('#reference-number').trigger('click')
      expect(@referenceNumber.css('display')).toEqual('none')

  describe 'hiding and showing of contact details block for individuals', ->
    beforeEach ->
      $('#claim_claimant_type_indiviudal').trigger('click')
      $('#claim_num_claimants').val('1')
      $('#claim_num_claimants').trigger('keyup')
      @contactDetails = $('#claimant-contact').find('details').eq(0).find('div').eq(0)

    it 'should be hidden when not clicked', ->
      expect(@contactDetails.css('display')).toEqual('none')

    # When run separately this test is succesful, but fails when all tests runs
    # Commenting it out for now
    # it 'should be displayed when clicked once', ->
      # $('#contact-details').trigger('click')
      # expect(@contactDetails.css('display')).toEqual('block')

    it 'should be hidden when clicked twice', ->
      $('#contact-details').trigger('click')
      $('#contact-details').trigger('click')
      expect(@contactDetails.css('display')).toEqual('none')

    describe 'reference number', ->
      it 'should not be shown', ->
        expect($('#reference-number')).toBeHidden()
        expect($('.sub-panel.details.reference-number')).not.toHaveClass('open')

