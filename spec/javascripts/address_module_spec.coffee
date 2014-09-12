//= require underscore
//= require jquery
//= require jasmine-jquery
//= require address_module



describe 'AddressModule', ->


  describe 'setup', ->
    it 'should call bindToAddressBoxes', ->
      spyOn window.AddressModule, 'bindToAddressBoxes'
      window.AddressModule.setup()
      expect(window.AddressModule.bindToAddressBoxes).toHaveBeenCalled()


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