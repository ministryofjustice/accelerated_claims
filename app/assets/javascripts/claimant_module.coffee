root = exports ? this

ClaimantModule =
  hideClaimantSections: ->
    $('.sub-panel.claimant').hide()

  showClaimants: (numberOfClaimants) ->
    ClaimantModule.hideClaimantSections()
    $('#num-claimants-error-message').hide()
    number = parseInt numberOfClaimants
    if number > 4
      $('#num-claimants-error-message').show()
    else
      if number > 0 and number < 5
        array = _.range(1, number + 1)
        _.each array, (i) ->
          id = "#claimant_#{i}_subpanel"
          $(id).show()

  bindToNumberClaimantsInput: ->
    $('#claim_num_claimants').on 'keyup', ->
      string = $(this).val()
      ClaimantModule.showClaimants(string)

  bindOrganisationLandlordSelectToShowFirstClaimant: ->
    $('#claim_claimant_type_organization').on 'change', ->
      if $( this ).is( ':checked' )
        ClaimantModule.showClaimants '1'
        ga('set', 'dimension1', 'organisation') if typeof ga is 'function'

  bindIndividualLandlordSelectToShowClaimants: ->
    $('#claim_claimant_type_individual').on 'change', ->
      if $( this ).is( ':checked' )
        ClaimantModule.showClaimants $('#claim_num_claimants').val()
        ga('set', 'dimension1', 'individual') if typeof ga is 'function'

  hideAddresses: ->
    $( '.same-address' ).each ->
      block = $( this )
      name = block.find('input[value="No"]').attr('name')
      sameAddress = block.find('input[name="' + name + '"]').filter(':checked').val()
      if( sameAddress == 'Yes' || !sameAddress)
        address = $( this ).find( '.sub-panel.address' )
        address.hide()

  bindNoCheckboxToShowAddress: ->
    $( '.same-address' ).each ->
      block = $( this )
      block.find('input[value="No"]').on 'change', ->
        if $(this).is( ':checked' )
          address_block_id = $(this).attr('id').replace('_address_same_as_first_claimant_no', '_postcode_selection_els')
          address_block = $("##{address_block_id}")
          address_block.show()

  setup: ->
    ClaimantModule.hideClaimantSections()
    ClaimantModule.bindToNumberClaimantsInput()
    ClaimantModule.bindOrganisationLandlordSelectToShowFirstClaimant()
    ClaimantModule.bindIndividualLandlordSelectToShowClaimants()
    ClaimantModule.showClaimants($('#claim_num_claimants').val())
    ClaimantModule.hideAddresses()
    ClaimantModule.bindNoCheckboxToShowAddress()

root.ClaimantModule = ClaimantModule

jQuery ->
  ClaimantModule.setup()