root = exports ? this

class ClaimantContact
  constructor: () ->
    @claimantContactPanel = $('.claimant-contact')
    @contactBlock = $('.sub-panel.details.contact-details')
    @addressBlock = $('.sub-panel.details.correspondence-address')
    @referenceBlock = $('.sub-panel.details.reference-number')

    @claimantContactPanel.hide()
    @hideDetailBlock(@contactBlock)
    @hideDetailBlock(@addressBlock)
    @hideDetailBlock(@referenceBlock)

    $('#claim_claimant_type_organization').on 'click', =>
      @claimantContactPanel.show()

    $('#claim_claimant_type_individual').on 'click', =>
      @hideContactPanelIfNumClaimantsBlank()

    $('#claim_num_claimants').on 'keyup', =>
      @showHideContactPanelDependingOnNumClaimants()

    $('a#contact-details').on 'click', =>
      @toggleDetails(@contactBlock)
      false

    $('a#correspondence-address').on 'click', =>
      @toggleDetails(@addressBlock)
      false

    $('a#reference-number').on 'click', =>
      @toggleDetails(@referenceBlock)
      false

  showHideContactPanelDependingOnNumClaimants: =>
    if (parseInt($('#claim_num_claimants').val()) < 1) || $('#claim_num_claimants').val() == ""
      @claimantContactPanel.hide()
    else
      @claimantContactPanel.show()

  hideContactPanelIfNumClaimantsBlank: ->
    if (parseInt($('#claim_num_claimants').val()) < 1) || $('#claim_num_claimants').val() == ""
      @claimantContactPanel.hide()

  hideDetailBlock: (element) =>
    element.removeClass('open')

  showDetailBlock: (element) =>
    element.addClass('open')

  toggleDetails: ( element ) =>
    console.log('toggle')
    if element.hasClass('open')
      console.log('--hide')
      @hideDetailBlock(element)
    else
      console.log('--show')
      @showDetailBlock(element)

root.ClaimantContact = ClaimantContact

jQuery ->
  new ClaimantContact( )

