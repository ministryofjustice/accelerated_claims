//= require underscore
//= require jquery
//= require jasmine-jquery
//= require property_module



describe 'PropertyModule', ->
  element = null


  beforeEach ->
    element = $(
      '<label for="claim_property_house_yes"><input id="claim_property_house_yes" name="pt" type="radio" value="Yes">A self-contained house, flat or bedsit</label></div>' +
      '<label for="claim_property_house_no"><input id="claim_property_house_no" name="pt" type="radio" value="No">Room(s) in a property <span class="hint">Tenants may share kitchen or bathroom</span></label>' +
      '<label for="street">Full Address<span class="hint hide toggle-hint" id="room_number"><br>Include the room number</span></label>'
    )
    $(document.body).append(element)
    window.PropertyModule.setup()
      
  afterEach ->
    element.remove()
    element = null


  describe 'setup', ->
    describe 'when neither button is checked', ->
      it 'should hide the room number prompt', ->
        room_number_prompt = $('#room_number')
        expect(room_number_prompt).toBeVisible()





