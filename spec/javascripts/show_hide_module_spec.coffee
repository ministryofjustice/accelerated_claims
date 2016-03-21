//= require underscore
//= require jquery
//= require jasmine-jquery
//= require show_hide_module


describe "ShowHideModule", ->
  element=null
  beforeEach ->
    element= $("""
      <section>
        <h2 class='section-header'>Claim costs</h2>
        <div class='moj-panel'>
          <div class='row'>
            <label class='visuallyhidden' for='claim_fee_court_fee'>Court fee - There is a fixed fee of two hundred and eighty pounds and no pence.  Enclose a check with the completed claim form.  This is not an editable text field.</label>
            Court fee <span class='hint block' aria-hidden="true">Enclose a cheque with the completed claim form</span>
            <input class="fee pound" id="claim_fee_court_fee" name="claim[fee][court_fee]" readonly="readonly" type="text" value="355.00" />
          </div>
          <div class='sub-panel'>
            <div class='row'><label for="claim_legal_cost_legal_costs"><span class="visuallyhidden">Fixed legal fees. Enter in pounds</span> <span aria-hidden="true">Fixed legal fees</span> <span class='hint block'>If the form is being completed by a legal representative</span></label>
            <input class="pound" id="claim_legal_cost_legal_costs" maxlength="8" name="claim[legal_cost][legal_costs]" size="8" type="text" value="600" /></div>
          </div>
          <div class='sub-panel'>
            <fieldset class="radio inline"><legend class="visuallyhidden">Do you want to ask the defendant to pay the cost of this claim? <span class='hint block'>You may be reimbursed the court fee (and fixed legal fees if applicable)</span></legend><div><span aria-hidden='true'>Do you want to ask the defendant to pay the cost of this claim?</span> <span class='hint block' aria-hidden='true'>You may be reimbursed the court fee (and fixed legal fees if applicable)</span></div><div class='options'><div class='option'><label for='claim_order_cost_yes'><input checked="checked" data-virtual-pageview="/accelerated/claim-costs-section" id="claim_order_cost_yes" name="claim[order][cost]" type="radio" value="Yes" />
            Yes</label></div>

            <div class='option'><label for='claim_order_cost_no'><input data-virtual-pageview="/accelerated/claim-costs-section" id="claim_order_cost_no" name="claim[order][cost]" type="radio" value="No" />
            No</label></div></div>
            </fieldset>
          </div>
          <div class='sub-panel details' id='fee-account-panel'>
            <div class='row js-only'>
              <a aria-expanded='false' class='caption show-hide-panel' href='#fee-account' id='fee-account'>
                If you have a fee account number, enter it here
              </a>
            </div>
            <div class='row'><label for="claim_fee_account"><span class="visuallyhidden">Fee account number, numeric only</span> <span aria-hidden="true">Fee account number</span> <span class='hint block'>Enter your Fee Account number (if applicable)</span></label>
            <input id="claim_fee_account" maxlength="10" name="claim[fee][account]" size="10" type="text" value="0000123456" /></div>
          </div>
        </div>
      </section>
    """)
    $(document.body).append(element)
    @detail = $('#fee-account-panel')
    @link = $('#fee-account')

  afterEach ->
    element.remove()
    element = null

  describe 'initial view', ->
    it 'should not expand fee account block', ->
      expect(@detail).not.toHaveClass('open')
      expect(@detail).toHaveClass('details')

    it 'should show fee account block after click', ->
      ShowHideModule.setup()
      @link.trigger('click')
      expect(@detail).toHaveClass('open')

    it 'should hide address block after second click', ->
      ShowHideModule.setup()
      @link.trigger('click')
      @link.trigger('click')
      expect(@detail).not.toHaveClass('open')
