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

  bindIndividualLandlordSelectToShowClaimants: ->
    $('#claim_claimant_type_individual').on 'change', ->
      if $( this ).is( ':checked' )
        ClaimantModule.showClaimants $('#claim_num_claimants').val()

  hideAddresses: ->
    $( '.same-address' ).each ->
      block = $( this )
      name = block.find('input[value="No"]').attr('name')
      sameAddress = block.find('input[name="' + name + '"]').filter(':checked').val()
      if( sameAddress == 'Yes' || !sameAddress)
        address = $( this ).find( '.sub-panel.address' )
        address.hide()

  setup: ->
    ClaimantModule.hideClaimantSections()
    ClaimantModule.bindToNumberClaimantsInput()
    ClaimantModule.bindOrganisationLandlordSelectToShowFirstClaimant()
    ClaimantModule.bindIndividualLandlordSelectToShowClaimants()
    ClaimantModule.showClaimants($('#claim_num_claimants').val())
    ClaimantModule.hideAddresses()

root.ClaimantModule = ClaimantModule

jQuery ->
  ClaimantModule.setup()