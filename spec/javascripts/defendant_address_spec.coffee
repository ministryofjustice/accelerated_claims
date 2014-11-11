//= require underscore
//= require jquery
//= require jasmine-jquery
//= require defendant_module


describe "DefendantModule", ->
  element=null
  beforeEach ->
    element= $("""
    <div class='defendant sub-panel' id='defendant_1_subpanel'>
          <div class='row divider'></div>
          <div class='row'>
            <h3>Defendant 1</h3>
          </div>
          <div id='claim_defendant_1_title_error' class='row title error'><label for="claim_defendant_1_title">Title<span class="visuallyhidden">.</span>  <span class='error'>Enter defendant 1's title</span>
          </label>
          <input class="smalltext" id="claim_defendant_1_title" maxlength="8" name="claim[defendant_1][title]" size="8" type="text" value="" /></div>
          <div id='claim_defendant_1_full_name_error' class='row rel error'><label for="claim_defendant_1_full_name">Full name<span class="visuallyhidden">.</span>  <span class='error'>Enter defendant 1's full name</span>
          </label>
          <input id="claim_defendant_1_full_name" maxlength="40" name="claim[defendant_1][full_name]" size="40" type="text" value="" /></div>
          <input id="claim_defendant_1_inhabits_property" name="claim[defendant_1][inhabits_property]" type="hidden" value="yes" />
          <div class='sub-panel details' id='defendant_1_resident_address'>
            <div class='row js-only'>
              <a aria-expanded='false' class='caption js-inhabitproperty show-hide' href='#defendant-1-resident-details' id='defendant_1_resident_details'>
                If the defendant is not living in the property, enter the address
              </a>
            </div>
            <div class='row hide nonjs'>If the defendant is not living in the property, enter the address</div>
            <div class='hide postcode postcode-picker-container' data-vc='all'>
              <div class='row postcode-lookup rel js-only'>
                <div class='postcode-display hide' style='margin-bottom: 20px;'>
                  Postcode:
                  <span class='postcode-display-detail' style='font-weight: bold'>
                    &nbsp;
                  </span>
                  <span>
                    <a class='change-postcode-link2 js-only' href='#dummy_anchor' id='claim_defendant_1-manual_change-link-2' style='display: inline; margin-left: 10px;'>Change</a>
                  </span>
                </div>
                <div class='postcode-selection-els'>
                  <label class='postcode-picker-label' for='claim_defendant_1_postcode_edit_field'>Postcode</label>
                  <input class='smalltext postcode-picker-edit-field' id='claim_defendant_1_postcode_edit_field' maxlength='8' name='[postcode]' size='8' type='text'>
                  <a class='button primary postcode-picker-button' data-country='all' href='#claim_defendant_1_postcode_picker'>
                    Find address
                  </a>
                </div>
                <div class='postcode-picker-hourglass hide'>
                  Finding address....
                </div>
                <div class='postcode-select-container sub-panel hide' style='margin-top: 0px;'>
                  <fieldset class='postcode-picker-address-list'>
                    <label class='hint' for='claim_defendant_1_address_select'>Please select an address</label>
                    <select class='address-picker-select' id='claim_defendant_1_address_select' name='sel-address' role='listbox' size='6'>
                      <option disabled='disabled' id='claim_defendant_1-listbox' role='option' value=''>Please select an address</option>
                    </select>
                    <a class='row button primary postcode-picker-cta' href='#claim_defendant_1_postcode_picker_manual_link' id='claim_defendant_1_selectaddress' style='margin-bottom: 20px;'>
                      Select address
                    </a>
                  </fieldset>
                </div>
              </div>
              <div class='js-only row'>
                <a class='caption postcode-picker-manual-link' href='#claim_defendant_1_postcode_picker_manual_link' id='claim_defendant_1_postcode_picker_manual_link' style='margin-top: 20px;'>
                  Enter address manually
                </a>
              </div>
              <div class='address extra no sub-panel hide' style='margin-top: 10px;'>
                <div class='row street'>
                  <label for='claim_defendant_1_street'>
                    Full address

                  </label>
                  <textarea class='street' id='claim_defendant_1_street' maxlength='70' name='claim[defendant_1][street]'></textarea>
                </div>
                <div class='row js-only'>
                  <span class='error hide' id='claim_defendant_1_street-error-message'>
                    The address can’t be longer than 4 lines.
                  </span>
                </div>
                <div class='row address-postcode'>
                  <label for='claim_defendant_1_postcode'>
                    Postcode
                  </label>
                  <br>
                  <div style='overflow: hidden; width: 100%'>
                    <input class='smalltext postcode' id='claim_defendant_1_postcode' maxlength='8' name='claim[defendant_1][postcode]' size='8' style='float: left;  margin-right: 20px;' type='text' value=''>
                    <a class='change-postcode-link js-only' href='#dummy_anchor' style='float: left;'>Change</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class='defendant sub-panel' id='defendant_2_subpanel'>
          <div class='row divider'></div>
          <div class='row'>
            <h3>Defendant 2 <span class='hint hide js-claimanttype'>(optional)</span></h3>
          </div>
          <div class='row title'><label for="claim_defendant_2_title">Title</label>
          <input class="smalltext" id="claim_defendant_2_title" maxlength="8" name="claim[defendant_2][title]" size="8" type="text" value="Mr" /></div>
          <div class='row rel'><label for="claim_defendant_2_full_name">Full name</label>
          <input id="claim_defendant_2_full_name" maxlength="40" name="claim[defendant_2][full_name]" size="40" type="text" value="Dee-fendant" /></div>
          <input id="claim_defendant_2_inhabits_property" name="claim[defendant_2][inhabits_property]" type="hidden" value="no" />
          <div class='sub-panel details' id='defendant_2_resident_address'>
            <div class='row js-only'>
              <a aria-expanded='false' class='caption js-inhabitproperty show-hide' href='#defendant-2-resident-details' id='defendant_2_resident_details'>
                If the defendant is not living in the property, enter the address
              </a>
            </div>
            <div class='row hide nonjs'>If the defendant is not living in the property, enter the address</div>
            <div class='hide postcode postcode-picker-container' data-vc='all'>
              <div class='row postcode-lookup rel js-only'>
                <div class='postcode-display hide' style='margin-bottom: 20px;'>
                  Postcode:
                  <span class='postcode-display-detail' style='font-weight: bold'>
                    &nbsp;
                  </span>
                  <span>
                    <a class='change-postcode-link2 js-only' href='#dummy_anchor' id='claim_defendant_2-manual_change-link-2' style='display: inline; margin-left: 10px;'>Change</a>
                  </span>
                </div>
                <div class='postcode-selection-els'>
                  <label class='postcode-picker-label' for='claim_defendant_2_postcode_edit_field'>Postcode</label>
                  <input class='smalltext postcode-picker-edit-field' id='claim_defendant_2_postcode_edit_field' maxlength='8' name='[postcode]' size='8' type='text'>
                  <a class='button primary postcode-picker-button' data-country='all' href='#claim_defendant_2_postcode_picker'>
                    Find address
                  </a>
                </div>
                <div class='postcode-picker-hourglass hide'>
                  Finding address....
                </div>
                <div class='postcode-select-container sub-panel hide' style='margin-top: 0px;'>
                  <fieldset class='postcode-picker-address-list'>
                    <label class='hint' for='claim_defendant_2_address_select'>Please select an address</label>
                    <select class='address-picker-select' id='claim_defendant_2_address_select' name='sel-address' role='listbox' size='6'>
                      <option disabled='disabled' id='claim_defendant_2-listbox' role='option' value=''>Please select an address</option>
                    </select>
                    <a class='row button primary postcode-picker-cta' href='#claim_defendant_2_postcode_picker_manual_link' id='claim_defendant_2_selectaddress' style='margin-bottom: 20px;'>
                      Select address
                    </a>
                  </fieldset>
                </div>
              </div>
              <div class='js-only row'>
                <a class='caption postcode-picker-manual-link' href='#claim_defendant_2_postcode_picker_manual_link' id='claim_defendant_2_postcode_picker_manual_link' style='margin-top: 20px;'>
                  Enter address manually
                </a>
              </div>
              <div class='address extra no sub-panel hide' style='margin-top: 10px;'>
                <div class='row street'>
                  <label for='claim_defendant_2_street'>
                    Full address

                  </label>
                  <textarea class='street' id='claim_defendant_2_street' maxlength='70' name='claim[defendant_2][street]'>7 Melbury Close&#x000A;FERNDOWN</textarea>
                </div>
                <div class='row js-only'>
                  <span class='error hide' id='claim_defendant_2_street-error-message'>
                    The address can’t be longer than 4 lines.
                  </span>
                </div>
                <div class='row address-postcode'>
                  <label for='claim_defendant_2_postcode'>
                    Postcode
                  </label>
                  <br>
                  <div style='overflow: hidden; width: 100%'>
                    <input class='smalltext postcode' id='claim_defendant_2_postcode' maxlength='8' name='claim[defendant_2][postcode]' size='8' style='float: left;  margin-right: 20px;' type='text' value='BH22 8HR'>
                    <a class='change-postcode-link js-only' href='#dummy_anchor' style='float: left;'>Change</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
    """)
    $(document.body).append(element)
    @detail = $('#defendant_1_resident_address')
    @link = $('#defendant_1_resident_details')

  afterEach ->
    element.remove()
    element = null

  describe 'initial view', ->
    it 'should not expand address block', ->
      DefendantModule.showDefendants(1)
      expect(@detail).not.toHaveClass('open')
      expect(@detail).toHaveClass('details')

    it 'should show address block after click', ->
      DefendantModule.setup()
      DefendantModule.showDefendants(1)
      $('#defendant_1_resident_details').trigger('click')
      expect(@detail).toHaveClass('open')

    it 'should hide address block after second click', ->
      DefendantModule.setup()
      DefendantModule.showDefendants(1)
      $('#defendant_1_resident_details').trigger('click')
      $('#defendant_1_resident_details').trigger('click')
      expect(@detail).not.toHaveClass('open')

    it 'should collapse the address block if the defendant is inhabits the property', ->
      @detail2 = $('#defendant_2_resident_address')
      DefendantModule.setup()
      DefendantModule.showDefendants(2)
      expect(@detail2).toHaveClass('open')
