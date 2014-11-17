//= require 'claimant_contact'

root = exports ? this

class ClaimantContact
  constructor: (claimantContactPanel) ->
    @claimantContactPanel = claimantContactPanel
    console.log "  DEBUG INITIALISING"
    claimantContactPanel.hide()
    @hideDetailBlocks()

    $('#claim_claimant_type_organization').on 'click', =>
      claimantContactPanel.show()

    $('#claim_claimant_type_individual').on 'click', =>
      @hideContactPanelIfNumClaimantsBlank()

    $('#claim_num_claimants').on 'keyup', =>
      @showHideContactPanelDependingOnNumClaimants()

    $('a#contact-details').on 'click', =>
      console.log "CLICKED"
      @toggleContactDetails()
      false

  showHideContactPanelDependingOnNumClaimants: =>
    if (parseInt($('#claim_num_claimants').val()) < 1) || $('#claim_num_claimants').val() == ""
      @claimantContactPanel.hide()
    else
      @claimantContactPanel.show()

  hideContactPanelIfNumClaimantsBlank: ->
    if (parseInt($('#claim_num_claimants').val()) < 1) || $('#claim_num_claimants').val() == ""
      @claimantContactPanel.hide()

  hideDetailBlocks: =>
    @hideContactDetailBlock()

  hideContactDetailBlock: =>
    $('.sub-panel.details.contact-details').removeClass('open')

  openContactDetailsBlock: =>
    $('.sub-panel.details.contact-details').addClass('open')

  toggleContactDetails: =>
    if $('.sub-panel.details.contact-details').hasClass('open')
      @hideContactDetailBlock()
    else
      @openContactDetailsBlock()

root.ClaimantContact = ClaimantContact

jQuery ->
  new ClaimantContact( $('.claimant-contact') )

