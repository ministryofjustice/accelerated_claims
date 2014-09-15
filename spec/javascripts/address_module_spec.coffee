//= require underscore
//= require jquery
//= require jasmine-jquery
//= require address_module



describe 'AddressModule', ->


  beforeEach ->
    html =  '''
      <div class="row street">
        <label for="claim_property_street">Full Address
          <div class="hint js-only" style="display: none;" id="room_number">Include the room number</div>
        </label>
        <textarea id="claim_property_street" maxlength="70" name="claim[property][street]"></textarea>
      </div>
      <div class="row street">
        <label for="claim_claimant_1_street">Full Address</label>
        <textarea id="claim_claimant_1_street" maxlength="70" name="claim[claimant][street]"></textarea>
      </div>
    '''
    $(document.body).append($(html))
  

  describe 'setup', ->
    it 'should call bindToAddressBoxes', ->
      spyOn window.AddressModule, 'bindToAddressBoxes'
      window.AddressModule.setup()
      expect(window.AddressModule.bindToAddressBoxes).toHaveBeenCalled()

    it 'should call checkNewlines once for each address box', ->
      spyOn window.AddressModule, 'checkNewlines'
      window.AddressModule.setup()
      expect(window.AddressModule.checkNewlines.calls.count()).toBe 2



  describe 'lastLineIsntWhiteSpace', ->
    it 'should return false if the last character is a newline', ->
      string = "abcbdl\n"
      expect(AddressModule.lastLineIsntWhiteSpace(string)).toBe false

    it 'should return false if the last characters is a newline followed by a space', ->
      string = "andhc\n "
      expect(AddressModule.lastLineIsntWhiteSpace(string)).toBe false      

    it 'should return false if the last characters are newline, tabs and spaces', ->
      string = 'abdbdn\nkjdfkkd\n\t\t '
      expect(AddressModule.lastLineIsntWhiteSpace(string)).toBe false            

    it 'should return true if there is anything other than whitespace after the last newline', ->
      string = 'abdbdn\nkjdfkkd\n xx  '
      expect(AddressModule.lastLineIsntWhiteSpace(string)).toBe true


  describe 'countNewlines', ->
    it 'should return 0 for text with no new lines', ->
      string = 'abdbdd'
      expect(AddressModule.countNewlines(string)).toBe 0

    it 'should return 4 for text with 4 newlines', ->
      string = "abdd\n\ndsdf\nsdf\n"
      expect(AddressModule.countNewlines(string)).toBe 4  