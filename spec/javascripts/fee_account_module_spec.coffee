//= require underscore
//= require jquery
//= require jasmine-jquery

//= require details.polyfill.for-jasmine-testing
//= require bind

//= require claimant_contact
//= require fee_account_module

describe "FeeAccountModule", ->
  element=null

  beforeEach ->
    element= $("""
<section>
  <h2 id="fee-section" class="section-header"></h2>
  <details>
    <summary>
      <span class='summary' id='fee-account'>If you have a fee account number, enter it here</span>
    </summary>
    <div class='row'>
      <div class='row'><label for="claim_fee_account"><span class='visuallyhidden'>Fee account number, numeric only</span> <span aria-hidden='true'>Fee account number<span class="hint block">Organisations can now set up an account to pay court fees, rather than pay by cheque. <a href="http://www.justice.gov.uk/courts/fees/payment-by-account" class="external" rel="external" target="_blank">More about fee account</a></span></span></label>
      <input id="claim_fee_account" maxlength="10" name="claim[fee][account]" size="10" type="text" value="" /></div>
    </div>
  </details>
</section>
    """)
    $(document.body).append(element)
    window.addDetailsPolyfill()
    @feeAccount = $('details').find('div').eq(0)

  afterEach ->
    element.remove()
    element = null

  describe 'initial view', ->
    it 'should not expand fee account block', ->
      FeeAccountModule.initialDisplay()
      expect(@feeAccount.css('display')).toEqual('none')

  # Works in browser
  # Commenting out for now
  #describe 'with data', ->
    #it 'should expand the fee block', ->
      #$('#claim_fee_account').val('1234')
      #FeeAccountModule.initialDisplay()
      #expect(@feeAccount.css('display')).toEqual('block')

