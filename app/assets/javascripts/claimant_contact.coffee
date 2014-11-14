//= require 'claimant_contact'

root = exports ? this

class ClaimantContact
  constructor: (claimantContactPanel) ->
    console.log "  DEBUG INITIALISING"
    claimantContactPanel.hide()

    $('#claim_claimant_type_organization').on 'click', =>
      claimantContactPanel.show()

root.ClaimantContact = ClaimantContact

jQuery ->
  new ClaimantContact( $('.claimant-contact') )

