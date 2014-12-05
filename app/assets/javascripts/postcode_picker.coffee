//= require 'postcode_lookup'

root = exports ? this

class PostcodePicker

  constructor: (picker) ->
    @picker             = picker                                                # The postcode picker container
    @selectElement      = picker.find('.address-picker-select')                 # The drop down box that will be populated with addresses
    @button             = picker.find('.postcode-picker-button')                # The find address button
    @input              = picker.find('.postcode-picker-edit-field')            # The edit box where the postcode is entered
    @valid_countries    = @normalizeCountry(@picker.data('vc'))                 # The list of valid countries for this picker
    manualLink          = picker.find('.postcode-picker-manual-link')           # The link to enter an address manually
    selectButton        = picker.find('.postcode-picker-cta')                   # The select address button
    changePostcodeLink  = picker.find('.change-postcode-link')                  # The Change link displayed after the address has been selected
    changePostcodeLink2 = picker.find('.change-postcode-link2')                 # The Change link displayed where the entered postcode is redisplayed above the drop down box

    # if the postcode is populated, then it means that the address was correctly selected earlier
    # and we want to display it.
    if @addressSuccessfullySelectedOnPreviousPage()
      @picker.find('.address.extra' ).show()                                    # Show the address block as if it were manually entered
      @picker.find('.postcode-selection-els').hide()                            # Hide the postocode entry edit field and Find Address button
      @picker.find('.postcode-display').hide()                                  # Hide the redisplay of the entered postcode
      @hideManualLink()                                                         # Hide the Enter Postcode Manually link

    if @errorsExistForStreetOrPostcode()
      @displayAddressFields()
      manualLink.show()                                                         # Show the manual link
      @picker.find('.postcode-selection-els').show()                            # Show the postocode entry edit field and Find Address button
      changePostcodeLink.hide()                                                 # Hide the chnage link next to the manual postcode

    if @streetAndPostcodeAlreadyEntered()
      @picker.find('.address-postcode input').attr('readonly', '1')             # Make the postcode box of the displayed address uneditable

    # Lookup postcode when Find Address button clicked
    #
    @button.on 'click', =>
      @lookupPostcode()

    # Display address entry fields when manual link is clicked
    manualLink.on 'click' , =>
      @toggleAddressFields()                                                    # Toggle visibility of address fields, blank out any values that they may contains
      changePostcodeLink.css('display', 'none')                                 # Hide the change postcode link
      @picker.find('.address-postcode input').removeAttr('readonly')            # Make Postcode edit field editable
      false

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
    if vc == 'all'
      result = 'UK'
    else
      # all of this crapola because IE 7 and 8 doesn't support the Array.map()  JS method
      countries = vc.split('+')
      capitalizedCountries = new Array
      x = 0
      loop
        capitalizedCountries.push(@capitalizeCountry(countries[x]))
        x = x + 1
        break if x == countries.length

      @toSentence(capitalizedCountries)

  capitalizeCountry: (vc) =>
    words = vc.split('_')
    result = (word.charAt(0).toUpperCase() + word.substr(1).toLowerCase() for word in words)
    result = result.join(' ')
    result = result.replace('Of', 'of')

  toSentence: (array) =>
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
    @picker.find('.address-postcode input').trigger('change')
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
      @clearAndDisplayAddressFields()

  hideAddressFields: ->
    @picker.find('.address').hide()
    @picker.find('.postcode-picker-manual-link').parent().removeClass('open')

  clearAndDisplayAddressFields: ->
    @picker.find('.street').val('')
    @picker.find('.postcode').val('')
    @displayAddressFields()

  displayAddressFields: ->
    @picker.find('.address').show()
    @picker.find('.postcode-picker-manual-link').parent().addClass('open')
    @picker.find('.street textarea').focus()

  displayInvalidPostcodeMessage: ->
    @addErrorMessage("Please enter a valid postcode in " + @valid_countries)
    @picker.find('.postcode-display').hide()
    @hideAddressFields()

  displayNoResultsFound: ->
    @addErrorMessage("No address found. Please enter the address manually")
    @picker.find('.postcode-display').hide()
    @hideAddressFields()

  displayServiceUnavailable: ->
    @clearAndDisplayAddressFields()
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
