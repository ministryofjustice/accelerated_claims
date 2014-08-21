root = exports ? this

ClaimantModule = 
  hideClaimantSections: ->
    console.log("hideClaimantSections")
    $('.sub-panel.claimant').hide()

  showClaimants: (numberOfClaimants) ->
    console.log("show claimants " + numberOfClaimants)
    ClaimantModule.hideClaimantSections()
    number = parseInt numberOfClaimants
    if number > 0 and number < 5 
      console.log("showing the stuff")
      array = _.range(1, number + 1)
      _.each array, (i) ->

        id = "#claimant_#{i}_subpanel"
        console.log("showing " + id)
        $(id).show()
    

  bindToNumberClaimantsInput: ->   
    console.log("bind") 
    $('#claim_num_claimants').on('keyup', ->
      string = $(this).val()
      ClaimantModule.showClaimants(string)
    )

  setup: ->
    console.log("AAAA")
    ClaimantModule.hideClaimantSections()
    console.log("BBBB")
    ClaimantModule.bindToNumberClaimantsInput()
    console.log("CCCC")
    ClaimantModule.showClaimants($('#claim_num_claimants').val())
    console.log("end of setup")


root.ClaimantModule = ClaimantModule

jQuery ->
  ClaimantModule.setup()