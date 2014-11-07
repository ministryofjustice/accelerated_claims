//= require 'postcode_lookup'

root = exports ? this

class PostcodePicker

  constructor: (picker) ->
    @picker = picker
    @selectElement = @picker.find('.address-picker-select')
    @button = picker.find('.postcode-picker-button')
    @input = picker.find('.postcode-picker-edit-field')
    manualLink = picker.find('.postcode-picker-manual-link')
    selectButton = picker.find('.postcode-picker-cta')
    changePostcodeLink = picker.find('.change-postcode-link')
    changePostcodeLink2 = picker.find('.change-postcode-link2')

    # if the postcode is populated, then it means that the address was correctly selected earlier
    # and we want to display it.
    if @addressSuccessfullySelectedOnPreviousPage() || @errorsExistForStreetOrPostcode()
      @picker.find('.address.extra' ).show()
      @picker.find('.postcode-selection-els').hide()
      @picker.find('.postcode-display').hide()
      @hideManualLink()

    if @streetAndPostcodeAlreadyEntered()
      @picker.find('.address-postcode input').attr('readonly', '1')



    @button.on 'click', =>
      @lookupPostcode()

    manualLink.on 'click', =>
      @toggleAddressFields()
      changePostcodeLink.css('display', 'none')
      @picker.find('.address-postcode input').removeAttr('readonly')

    @input.on 'keyup', =>
      @clearPostcodeErrorMessage()

    selectButton.on 'click', =>
      @selectAddress()

    changePostcodeLink.on 'click', =>
      @hideAddressFields()
      @showManualLink()
      @picker.find('.postcode-selection-els').show()
      @input.val('')
      @input.focus()
      

    changePostcodeLink2.on 'click', =>
      @picker.find('.postcode-display').hide()
      @picker.find('.postcode-select-container').hide()
      @showPostcodeSearchComponent()
   

  normalizeCountry: (vc) =>
    console.log 'Normalizing ' + vc
    if vc == 'all'
      result = 'UK'
    else 
      countries = vc.split('+')
      console.log JSON.stringify(countries)
      @toSentence(countries.map (country) => @capitalizeCountry(country))

  capitalizeCountry: (vc) =>
    words = vc.split('_')
    result = (word[0].toUpperCase() + word[1..-1].toLowerCase() for word in vc.split('_')).join ' '
    result = result.replace('Of', 'of')

  toSentence: (array) ->
    if array.length > 1
      last_item = array.pop()
      result = array.join(', ')
      result = result + " and " + last_item
    else
      result = array[0]
      
    result


  streetAndPostcodeAlreadyEntered: =>
    @picker.find('input.smalltext.postcode').val() != '' && @picker.find('.street textarea').val() != ''


  addressSuccessfullySelectedOnPreviousPage: =>
    @picker.find('input.smalltext.postcode').val() != ''


  errorsExistForStreetOrPostcode: =>
    @picker.find('.street.error').size() != 0 || @picker.find('.address-postcode.error').size() != 0

  hideManualLink: =>
    @picker.find('.postcode-picker-manual-link').hide()

  showManualLink: =>
    @picker.find('.postcode-picker-manual-link').show()

  lookupPostcode: (country) =>
    postcode = @input.val()
    country = @button.data('country')
    @picker.find('.postcode-display').show()
    @picker.find('.postcode-select-container').hide()
    @showManualLink()
    window.PostcodeLookup.lookup(postcode, country, this)

  selectAddress: =>
    index = parseInt @picker.find('option:selected').val()
    selectedAddress = @addresses[index]
    street = selectedAddress.address.replace(/;;/g, "\n")
    postcode = selectedAddress.postcode
    @picker.find('.street textarea').val(street)
    @picker.find('.address-postcode input').val(postcode)
    @picker.find('.address-postcode input').attr('readonly', '1')

    @picker.find('.postcode-picker-address-list').hide()
    
    @picker.find('.address.extra' ).show()
    @picker.find('.postcode-selection-els').hide()
    @picker.find('.postcode-display').hide()
    @hideManualLink()
    @picker.find('.change-postcode-link').css('display', 'inline')
    @picker.find('.street textarea').focus()

  handleSuccessfulResponse: (response) ->
    if response.code == 2000
      @displayAddresses(response.result)
    else
      @displayInvalidCountryMessage(response)

  displayInvalidCountryMessage: (response) ->
    @picker.find('.postcode-display').hide()
    @addErrorMessage("Postcode is in #{response.message}. You can only use this service to regain possession of properties in England and Wales.")

  displayAddresses: (addresses) ->
    @addresses = addresses
    @hideAddressFields()
    @hidePostcodeSearchComponent()
    @selectElement.empty()
    @picker.find('.postcode-display').removeClass('hide')
    @picker.find('.postcode-display-detail').html(addresses[0].postcode)
    $.each addresses, (index, address) =>
      address = address.address.replace(/;;/g, ", ")
      option = "<option value=\"#{index}\">#{address}</option>"
      @selectElement.append option
    @picker.find('.postcode-select-container').show()
    @picker.find('.postcode-picker-address-list').show()
    @picker.find('.address-picker-select').focus()
    true
    
  hidePostcodeSearchComponent: ->
    @picker.find('.postcode-selection-els').hide()

  showPostcodeSearchComponent: ->
    @picker.find('.postcode-selection-els').show()
    @input.focus()
    true

  toggleAddressFields: ->
    if @picker.find('.address').is(':visible')
      @hideAddressFields()
    else
      @displayAddressFields()

  hideAddressFields: ->
    @picker.find('.address').hide()
    @picker.find('.postcode-picker-manual-link').parent().removeClass('open')

  displayAddressFields: ->
    @picker.find('.street').val('')
    @picker.find('.postcode').val('')
    @picker.find('.address').show()
    @picker.find('.postcode-picker-manual-link').parent().addClass('open')
    @picker.find('.street textarea').focus()

  displayInvalidPostcodeMessage: ->
    @addErrorMessage('Please enter a valid UK postcode')
    @picker.find('.postcode-display').hide()
    @hideAddressFields()

  displayNoResultsFound: ->
    @addErrorMessage('No address found. Please enter the address manually')
    @picker.find('.postcode-display').hide()
    @hideAddressFields()

  displayServiceUnavailable: ->
    @displayAddressFields()
    @addErrorMessage('Postcode lookup service not available. Please enter the address manually.')

  clearPostcodeErrorMessage: ->
    @picker.find('.error.postcode').detach()

  addErrorMessage: (text) ->
    @clearPostcodeErrorMessage()
    @button.after("<span class=\"error postcode\">#{text}</span>")

root.PostcodePicker = PostcodePicker

jQuery ->
   _.each $('.postcode-picker-container'), (picker) ->
     new PostcodePicker( $(picker) )

