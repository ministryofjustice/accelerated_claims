root = exports ? this

ClaimantModule = 
  hideClaimantSections: ->
    $('.sub-panel.claimant').hide()

  showClaimants: (numberOfClaimants) ->
    ClaimantModule.hideClaimantSections()
    number = parseInt numberOfClaimants
    if number > 4
      alert('The maxiumum number of claimants is 4')
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


  setup: ->
    ClaimantModule.hideClaimantSections()
    ClaimantModule.bindToNumberClaimantsInput()
    ClaimantModule.bindOrganisationLandlordSelectToShowFirstClaimant()
    ClaimantModule.bindIndividualLandlordSelectToShowClaimants()
    ClaimantModule.showClaimants($('#claim_num_claimants').val())


root.ClaimantModule = ClaimantModule

jQuery ->
  ClaimantModule.setup()