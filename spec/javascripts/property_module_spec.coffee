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
      '<label for="street">Full Address<span class="hint toggle-hint" id="room_number"><br>Include the room number</span></label>'
    )
    $(document.body).append(element)
    window.PropertyModule.setup()
      
  afterEach ->
    element.remove()
    element = null


  describe 'clicking on radio buttons', ->
    it 'should hide the house number prompt when house clicked', ->
      $('#claim_property_house_yes').trigger('click')
      expect($('#room_number')).toBeHidden()

    it 'should show the house number prompt when rooms clicked', ->
      $('#claim_property_house_no').trigger('click')
      expect($('#room_number')).toBeVisible()
 

