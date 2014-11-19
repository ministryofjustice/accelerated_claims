//= require moj
//= require underscore
//= require jquery
//= require claimant_module
//= require show_hide_module
//= require show_hide

//= require jquery_ujs
//= require handlebars-v1.3.0
//= require jquery.simplemodal-1.4.5
//= require tools
//= require animate

//= require address_module
//= require postcode_picker

//= require property_module
//= require select_state
//= require yes_no
//= require claimant_contact
//= require claimant_module
//= require defendant_module
//= require deposit_module
//= require notice_module
//= require tenancy_module
//= require date_digits
//= require show_hide
//= require js_validate
//= require scrolling
//= require js_alt_text
//= require not_applicable
//= require session_modal
//= require show_hide_module
//= require fee_account_module

//= require event_tracker
//= require pageview_tracker
//= require analytics_tracking
//= require relative_url_root
//= require end_timer
//= require session_timeoutjs

//= require js_state

//= require error_focus_module

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
    <h2 class="section-header" id="claimant-section">Claimants</h2>
    <div class="moj-panel" data-caption="As the landlord, you're known as the <strong>claimant</strong> in this case." data-multiple="claimant" data-plural="claimants" data-single="claimant" id="claimants">
      <div class="row">
        As the landlord, you’re known as the <b>claimant</b> in this case.
      </div>
      <fieldset class="radio js-depend" data-depend="claimanttype"><legend class="visuallyhidden">What kind of claimant are you?</legend><div><span aria-hidden="true">What kind of claimant are you?</span></div><div class="options"><div class="option"><label for="claim_claimant_type_individual"><input data-virtual-pageview="/accelerated/claimants-section" id="claim_claimant_type_individual" name="claim[claimant_type]" type="radio" value="individual">
      A private landlord (individual)</label></div>

      <div class="option"><label for="claim_claimant_type_organization" class="highlight"><input data-virtual-pageview="/accelerated/claimants-section" id="claim_claimant_type_organization" name="claim[claimant_type]" type="radio" value="organization">
      A private landlord (company), a local authority or a housing association</label></div></div>
      </fieldset>
      <div class="row hide js-claimanttype individual" style="display: none;"><label for="claim_num_claimants">How many claimants are there? <br><span class="hint">All claimants should be named on the tenancy agreement</span></label>
      <input class="narrow" data-depend="num-claimants" id="claim_num_claimants" name="claim[num_claimants]" type="text"></div>
      <div class="row js-only">
        <span class="error hide" id="num-claimants-error-message" style="display: none;">
          The number of claimants must be between 1 and 4. If you have more than 4 claimants, you’ll need to complete your
          accelerated possession claim on the <a href="http://hmctsformfinder.justice.gov.uk/HMCTS/GetForm.do?court_forms_id=618">N5b form</a>
        </span>
      </div>
      <div class="claimants">
        <div class="claimant sub-panel" data-claimant-id="1" id="claimant_1_subpanel" style="display: block;">
          <div class="row divider"></div>
          <div class="row">
            <h3>Claimant 1</h3>
          </div>
          <div class="row title hide js-claimanttype individual" style="display: none;"><label for="claim_claimant_1_title">Title</label>
          <input class="smalltext" id="claim_claimant_1_title" maxlength="8" name="claim[claimant_1][title]" size="8" type="text"></div>
          <div class="row rel hide js-claimanttype individual" style="display: none;"><label for="claim_claimant_1_full_name">Full name</label>
          <input id="claim_claimant_1_full_name" maxlength="40" name="claim[claimant_1][full_name]" size="40" type="text"></div>

          <div class="row rel hide js-claimanttype organization" style="display: block;"><label for="claim_claimant_1_organization_name">Company name or local authority name</label>
          <input id="claim_claimant_1_organization_name" name="claim[claimant_1][organization_name]" type="text"></div>
          <div class="sub-panel rel address">
            <div class="postcode postcode-picker-container" data-vc="all">
              <div class="row postcode-lookup rel js-only">
                <div class="postcode-display hide" style="margin-bottom: 20px;">
                  Postcode:
                  <span class="postcode-display-detail" style="font-weight: bold">
                    &nbsp;
                  </span>
                  <span>
                    <a class="change-postcode-link2 js-only" href="#dummy_anchor" id="claim_claimant_1-manual_change-link-2" style="display: inline; margin-left: 10px;">Change</a>
                  </span>
                </div>
                <div class="postcode-selection-els">
                  <label class="postcode-picker-label" for="claim_claimant_1_postcode_edit_field">Postcode</label>
                  <input class="smalltext postcode-picker-edit-field" id="claim_claimant_1_postcode_edit_field" maxlength="8" name="[postcode]" size="8" type="text">
                  <a class="button primary postcode-picker-button" data-country="all" href="#claim_claimant_1_postcode_picker">
                    Find address
                  </a>
                </div>
                <div class="postcode-picker-hourglass hide">
                  Finding address....
                </div>
                <div class="postcode-select-container sub-panel hide" style="margin-top: 0px;">
                  <fieldset class="postcode-picker-address-list">
                    <label class="hint" for="claim_claimant_1_address_select">Please select an address</label>
                    <select class="address-picker-select" id="claim_claimant_1_address_select" name="sel-address" role="listbox" size="6">
                      <option disabled="disabled" id="claim_claimant_1-listbox" role="option" value="">Please select an address</option>
                    </select>
                    <a class="row button primary postcode-picker-cta" href="#claim_claimant_1_postcode_picker_manual_link" id="claim_claimant_1_selectaddress" style="margin-bottom: 20px;">
                      Select address
                    </a>
                  </fieldset>
                </div>
              </div>
              <div class="js-only row">
                <a class="caption postcode-picker-manual-link" href="#claim_claimant_1_postcode_picker_manual_link" id="claim_claimant_1_postcode_picker_manual_link" style="margin-top: 20px;">
                  Enter address manually
                </a>
              </div>
              <div class="address extra no sub-panel hide" style="margin-top: 10px;">
                <div class="row street">
                  <label for="claim_claimant_1_street">
                    Full address

                  </label>
                  <textarea class="street" id="claim_claimant_1_street" maxlength="70" name="claim[claimant_1][street]"></textarea>
                </div>
                <div class="row js-only">
                  <span class="error hide" id="claim_claimant_1_street-error-message">
                    The address can’t be longer than 4 lines.
                  </span>
                </div>
                <div class="row address-postcode">
                  <label for="claim_claimant_1_postcode">
                    Postcode
                  </label>
                  <br>
                  <div style="overflow: hidden; width: 100%">
                    <input class="smalltext postcode" id="claim_claimant_1_postcode" maxlength="8" name="claim[claimant_1][postcode]" size="8" style="float: left;  margin-right: 20px;" type="text" value="">
                    <a class="change-postcode-link js-only" href="#dummy_anchor" style="float: left;">Change</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="claimant same-address sub-panel" data-claimant-id="2" id="claimant_2_subpanel" style="display: none;">
          <div class="row divider"></div>
          <div class="row">
            <h3>Claimant 2 <span class="hint hide js-claimanttype" style="display: none;">(optional)</span></h3>
          </div>
          <div class="row title hide js-claimanttype individual" style="display: none;"><label for="claim_claimant_2_title">Title</label>
          <input class="smalltext" id="claim_claimant_2_title" maxlength="8" name="claim[claimant_2][title]" size="8" type="text"></div>
          <div class="row rel hide js-claimanttype individual" style="display: none;"><label for="claim_claimant_2_full_name">Full name</label>
          <input id="claim_claimant_2_full_name" maxlength="40" name="claim[claimant_2][full_name]" size="40" type="text"></div>
          <div class="sub-panel js-only">
            <fieldset class="radio inline"><legend class="visuallyhidden">Is the address the same as the first claimant?</legend><div><span aria-hidden="true">Is the address the same as the first claimant?</span></div><div class="options" data-reverse="true"><div class="option"><label for="claim_claimant_2_address_same_as_first_claimant_yes"><input class="yesno" id="claim_claimant_2_address_same_as_first_claimant_yes" name="claim[claimant_2][address_same_as_first_claimant]" type="radio" value="Yes">
            Yes</label></div>

            <div class="option"><label for="claim_claimant_2_address_same_as_first_claimant_no"><input class="yesno" id="claim_claimant_2_address_same_as_first_claimant_no" name="claim[claimant_2][address_same_as_first_claimant]" type="radio" value="No">
            No</label></div></div>
            </fieldset>
          </div>
          <div class="sub-panel rel address" style="display: none;">
            <div class="postcode postcode-picker-container" data-vc="all">
              <div class="row postcode-lookup rel js-only">
                <div class="postcode-display hide" style="margin-bottom: 20px;">
                  Postcode:
                  <span class="postcode-display-detail" style="font-weight: bold">
                    &nbsp;
                  </span>
                  <span>
                    <a class="change-postcode-link2 js-only" href="#dummy_anchor" id="claim_claimant_2-manual_change-link-2" style="display: inline; margin-left: 10px;">Change</a>
                  </span>
                </div>
                <div class="postcode-selection-els">
                  <label class="postcode-picker-label" for="claim_claimant_2_postcode_edit_field">Postcode</label>
                  <input class="smalltext postcode-picker-edit-field" id="claim_claimant_2_postcode_edit_field" maxlength="8" name="[postcode]" size="8" type="text">
                  <a class="button primary postcode-picker-button" data-country="all" href="#claim_claimant_2_postcode_picker">
                    Find address
                  </a>
                </div>
                <div class="postcode-picker-hourglass hide">
                  Finding address....
                </div>
                <div class="postcode-select-container sub-panel hide" style="margin-top: 0px;">
                  <fieldset class="postcode-picker-address-list">
                    <label class="hint" for="claim_claimant_2_address_select">Please select an address</label>
                    <select class="address-picker-select" id="claim_claimant_2_address_select" name="sel-address" role="listbox" size="6">
                      <option disabled="disabled" id="claim_claimant_2-listbox" role="option" value="">Please select an address</option>
                    </select>
                    <a class="row button primary postcode-picker-cta" href="#claim_claimant_2_postcode_picker_manual_link" id="claim_claimant_2_selectaddress" style="margin-bottom: 20px;">
                      Select address
                    </a>
                  </fieldset>
                </div>
              </div>
              <div class="js-only row">
                <a class="caption postcode-picker-manual-link" href="#claim_claimant_2_postcode_picker_manual_link" id="claim_claimant_2_postcode_picker_manual_link" style="margin-top: 20px;">
                  Enter address manually
                </a>
              </div>
              <div class="address extra no sub-panel hide" style="margin-top: 10px; display: none;">
                <div class="row street">
                  <label for="claim_claimant_2_street">
                    Full address

                  </label>
                  <textarea class="street" id="claim_claimant_2_street" maxlength="70" name="claim[claimant_2][street]"></textarea>
                </div>
                <div class="row js-only">
                  <span class="error hide" id="claim_claimant_2_street-error-message">
                    The address can’t be longer than 4 lines.
                  </span>
                </div>
                <div class="row address-postcode">
                  <label for="claim_claimant_2_postcode">
                    Postcode
                  </label>
                  <br>
                  <div style="overflow: hidden; width: 100%">
                    <input class="smalltext postcode" id="claim_claimant_2_postcode" maxlength="8" name="claim[claimant_2][postcode]" size="8" style="float: left;  margin-right: 20px;" type="text" value="">
                    <a class="change-postcode-link js-only" href="#dummy_anchor" style="float: left;">Change</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="row divider"></div>

      <div class="sub-panel claimant-contact" style="display: block;">
        <div class="sub-panel details contact-details">
          <div class="row js-only">
            <a aria-expanded="false" class="caption" href="#contact-details" id="contact-details">
              Add phone and email
            </a>
            <span class="hint">(Optional)</span>
          </div>
          <div class="row rel email"><label for="claim_claimant_contact_email">Email</label>
          <input id="claim_claimant_contact_email" name="claim[claimant_contact][email]" type="text"></div>
          <div class="row rel phone"><label for="claim_claimant_contact_phone">Phone</label>
          <input id="claim_claimant_contact_phone" name="claim[claimant_contact][phone]" type="text"></div>
          <div class="row rel fax"><label for="claim_claimant_contact_fax">Fax</label>
          <input id="claim_claimant_contact_fax" maxlength="40" name="claim[claimant_contact][fax]" size="40" type="text"></div>
          <div class="row rel dx_number"><label for="claim_claimant_contact_dx_number">DX number</label>
          <input id="claim_claimant_contact_dx_number" maxlength="40" name="claim[claimant_contact][dx_number]" size="40" type="text"></div>
        </div>
        <div class="row">
          If you want us to send correspondence about the case to a different address, enter it here.
          <span class="hint block js-claimanttype individual js-only" style="display: none;">
            eg a legal representative's address (Optional)
          </span>
          <span class="hint block js-claimanttype organization" style="display: block;">
            eg a legal representative or managing agent's address (Optional)
          </span>
        </div>
        <div class="sub-panel details correspondence-address">
          <div class="row js-only correspondence-address">
            <a aria-expanded="false" class="caption" href="#correspondence-address" id="correspondence-address">
              Add alternative address
            </a>
            <span class="hint">(Optional)</span>
          </div>
          <div class="row rel title"><label for="claim_claimant_contact_title">Title</label>
          <input class="smalltext" id="claim_claimant_contact_title" maxlength="8" name="claim[claimant_contact][title]" size="8" type="text"></div>
          <div class="row rel"><label for="claim_claimant_contact_full_name">Full name</label>
          <input id="claim_claimant_contact_full_name" maxlength="40" name="claim[claimant_contact][full_name]" size="40" type="text"></div>
          <div class="row rel company_name"><label for="claim_claimant_contact_company_name">Company name</label>
          <input id="claim_claimant_contact_company_name" maxlength="40" name="claim[claimant_contact][company_name]" size="40" type="text"></div>
          <div class="hide postcode postcode-picker-container" data-vc="all">
            <div class="row postcode-lookup rel js-only">
              <div class="postcode-display hide" style="margin-bottom: 20px;">
                Postcode:
                <span class="postcode-display-detail" style="font-weight: bold">
                  &nbsp;
                </span>
                <span>
                  <a class="change-postcode-link2 js-only" href="#dummy_anchor" id="claim_claimant_contact-manual_change-link-2" style="display: inline; margin-left: 10px;">Change</a>
                </span>
              </div>
              <div class="postcode-selection-els">
                <label class="postcode-picker-label" for="claim_claimant_contact_postcode_edit_field">Postcode</label>
                <input class="smalltext postcode-picker-edit-field" id="claim_claimant_contact_postcode_edit_field" maxlength="8" name="[postcode]" size="8" type="text">
                <a class="button primary postcode-picker-button" data-country="all" href="#claim_claimant_contact_postcode_picker">
                  Find address
                </a>
              </div>
              <div class="postcode-picker-hourglass hide">
                Finding address....
              </div>
              <div class="postcode-select-container sub-panel hide" style="margin-top: 0px;">
                <fieldset class="postcode-picker-address-list">
                  <label class="hint" for="claim_claimant_contact_address_select">Please select an address</label>
                  <select class="address-picker-select" id="claim_claimant_contact_address_select" name="sel-address" role="listbox" size="6">
                    <option disabled="disabled" id="claim_claimant_contact-listbox" role="option" value="">Please select an address</option>
                  </select>
                  <a class="row button primary postcode-picker-cta" href="#claim_claimant_contact_postcode_picker_manual_link" id="claim_claimant_contact_selectaddress" style="margin-bottom: 20px;">
                    Select address
                  </a>
                </fieldset>
              </div>
            </div>
            <div class="js-only row">
              <a class="caption postcode-picker-manual-link" href="#claim_claimant_contact_postcode_picker_manual_link" id="claim_claimant_contact_postcode_picker_manual_link" style="margin-top: 20px;">
                Enter address manually
              </a>
            </div>
            <div class="address extra no sub-panel hide" style="margin-top: 10px;">
              <div class="row street">
                <label for="claim_claimant_contact_street">
                  Full address

                </label>
                <textarea class="street" id="claim_claimant_contact_street" maxlength="70" name="claim[claimant_contact][street]"></textarea>
              </div>
              <div class="row js-only">
                <span class="error hide" id="claim_claimant_contact_street-error-message">
                  The address can’t be longer than 4 lines.
                </span>
              </div>
              <div class="row address-postcode">
                <label for="claim_claimant_contact_postcode">
                  Postcode
                </label>
                <br>
                <div style="overflow: hidden; width: 100%">
                  <input class="smalltext postcode" id="claim_claimant_contact_postcode" maxlength="8" name="claim[claimant_contact][postcode]" size="8" style="float: left;  margin-right: 20px;" type="text" value="">
                  <a class="change-postcode-link js-only" href="#dummy_anchor" style="float: left;">Change</a>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="sub-panel details js-claimanttype organization reference-number" style="display: block;">
          <div class="row js-only">
            <a aria-expanded="false" class="caption" href="#reference-number" id="reference-number">
              Add a reference number
            </a>
            <span class="hint">(Optional)</span>
          </div>
          <div class="row rel reference_number"><label for="claim_reference_number_reference_number">You can add a reference number for your own use<span class="hint"> (Optional)</span></label>
          <input id="claim_reference_number_reference_number" maxlength="40" name="claim[reference_number][reference_number]" size="40" type="text"></div>
        </div>
      </div>
    </div>
  </section>
</body>""")

    $(document.body).append(element)
    @panel = $('.claimant-contact')
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
      expect($('#reference-number')).toBeVisible()

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

    it 'should be displayed when clicked once', ->
      $('a.caption#contact-details').trigger('click')
      expect($('.sub-panel.details.contact-details')).toHaveClass('open')

    it 'should be hidden if clicked twice', ->
      $('a.caption#contact-details').trigger('click')
      expect($('.sub-panel.details.contact-details')).toHaveClass('open')

      $('a.caption#contact-details').trigger('click')
      expect($('.sub-panel.details.contact-details')).not.toHaveClass('open')

  describe 'hiding and showing of alternative address block for organizations', ->
    beforeEach ->
      $('#claim_claimant_type_organization').trigger('click')
      @pcp = @panel.find('.postcode-picker-container')

    it 'should be displayed when clicked once', ->
      $('a.caption#correspondence-address').trigger('click')
      expect($('.sub-panel.details.correspondence-address')).toHaveClass('open')

    it 'should be hidden if clicked twice', ->
      $('a.caption#correspondence-address').trigger('click')
      expect($('.sub-panel.details.correspondence-address')).toHaveClass('open')

      $('a.caption#correspondence-address').trigger('click')
      expect($('.sub-panel.details.correspondence-address')).not.toHaveClass('open')

    it 'should show postcode picker when clicked once', ->
      expect(@pcp).toHaveClass('hide')
      $('a.caption#correspondence-address').trigger('click')
      expect(@pcp).not.toHaveClass('hide')

  describe 'hiding and showing of reference number block for organizations', ->
    beforeEach ->
      $('#claim_claimant_type_organization').trigger('click')

    it 'should be displayed when clicked once', ->
      $('a.caption#reference-number').trigger('click')
      expect($('.sub-panel.details.reference-number')).toHaveClass('open')

    it 'should be hidden if clicked twice', ->
      $('a.caption#reference-number').trigger('click')
      expect($('.sub-panel.details.reference-number')).toHaveClass('open')

      $('a.caption#reference-number').trigger('click')
      expect($('.sub-panel.details.reference-number')).not.toHaveClass('open')

  describe 'hiding and showing of contact details block for individuals', ->
    beforeEach ->
      $('#claim_claimant_type_indiviudal').trigger('click')
      $('#claim_num_claimants').val('1')
      $('#claim_num_claimants').trigger('keyup')

    it 'should be displayed when clicked once', ->
      $('a.caption#contact-details').trigger('click')
      expect($('.sub-panel.details.contact-details')).toHaveClass('open')

    it 'should be hidden if clicked twice', ->
      $('a.caption#contact-details').trigger('click')
      expect($('.sub-panel.details.contact-details')).toHaveClass('open')

      $('a.caption#contact-details').trigger('click')
      expect($('.sub-panel.details.contact-details')).not.toHaveClass('open')

    describe 'reference number', ->
      it 'should not be shown', ->
        expect($('#reference-number')).toBeHidden()
        expect($('.sub-panel.details.reference-number')).not.toHaveClass('open')

