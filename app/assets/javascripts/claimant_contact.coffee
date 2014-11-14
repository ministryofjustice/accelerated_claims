//= require 'claimant_contact'

root = exports ? this

class ClaimantContact
  constructor: (claimantContactPanel) ->
    @claimantContactPanel = claimantContactPanel
    console.log "  DEBUG INITIALISING"
    claimantContactPanel.hide()

    $('#claim_claimant_type_organization').on 'click', =>
      claimantContactPanel.show()

    $('#claim_claimant_type_individual').on 'click', =>
      @hideContactPanelIfNumClaimantsBlank()

    $('#claim_num_claimants').on 'keyup', =>
      @showHideContactPanelDependingOnNumClaimants()

  showHideContactPanelDependingOnNumClaimants: =>
    if (parseInt($('#claim_num_claimants').val()) < 1) || $('#claim_num_claimants').val() == ""
      @claimantContactPanel.hide()
    else
      @claimantContactPanel.show()

  hideContactPanelIfNumClaimantsBlank: ->
    if (parseInt($('#claim_num_claimants').val()) < 1) || $('#claim_num_claimants').val() == ""
      @claimantContactPanel.hide()

root.ClaimantContact = ClaimantContact

jQuery ->
  new ClaimantContact( $('.claimant-contact') )

