root = exports ? this

class ClaimantContact
  constructor: () ->
    @claimantContactPanel = $('.claimant-contact')
    @contactBlock = $('.sub-panel.details.contact-details')
    @addressBlock = $('.sub-panel.details.correspondence-address')
    @referenceBlock = $('.sub-panel.details.reference-number')
    @buttonIndividual = $('#claim_claimant_type_individual')
    @buttonOrganization = $('#claim_claimant_type_organization')
    @pcp = @claimantContactPanel.find('.postcode-picker-container').first()

    @claimantContactPanel.hide()
    @hideDetailBlock(@contactBlock)
    @hideDetailBlock(@addressBlock)
    @hideDetailBlock(@referenceBlock)
    @displayOnLoad()

    @buttonOrganization.on 'click', =>
      @claimantContactPanel.show()

    @buttonIndividual.on 'click', =>
      @hideContactPanelIfNumClaimantsBlank()

    $('#claim_num_claimants').on 'keyup', =>
      @showHideContactPanelDependingOnNumClaimants()

    $('a#contact-details').on 'click', =>
      @toggleDetails(@contactBlock)
      false

    $('a#correspondence-address').on 'click', =>
      @toggleDetails(@addressBlock)
      if @addressBlock.hasClass('open')
        @pcp.addClass('show').removeClass('hide')
      else
        @pcp.addClass('hide').removeClass('show')
      false

    $('a#reference-number').on 'click', =>
      @toggleDetails(@referenceBlock)
      false

  displayOnLoad: =>
    if @buttonOrganization.is(':checked')
      @claimantContactPanel.show()
    else if @buttonIndividual.is(':checked')
      @hideContactPanelIfNumClaimantsBlank()
    @expandBlockIfPopulated(@addressBlock)
    @expandBlockIfPopulated(@contactBlock)
    if @addressBlock.hasClass('open')
      @pcp.addClass('show').removeClass('hide')
    else
      @pcp.addClass('hide').removeClass('show')

  showHideContactPanelDependingOnNumClaimants: =>
    if (parseInt($('#claim_num_claimants').val()) < 1) || $('#claim_num_claimants').val() == ""
      @claimantContactPanel.hide()
    else
      @claimantContactPanel.show()
      @referenceBlock.hide() unless $('#claim_claimant_type_organization').is(':checked')

  hideContactPanelIfNumClaimantsBlank: ->
    if (parseInt($('#claim_num_claimants').val()) < 1) || $('#claim_num_claimants').val() == ""
      @claimantContactPanel.hide()
    else
      @claimantContactPanel.show()

  hideDetailBlock: (element) =>
    element.removeClass('open')

  showDetailBlock: (element) =>
    element.addClass('open')

  expandBlockIfPopulated: (element) =>
    if element.is(':visible')
      if element.find('input').filter( -> this.value != '').length > 0
        @showDetailBlock(element)

  toggleDetails: ( element ) =>
    if element.hasClass('open')
      @hideDetailBlock(element)
    else
      @showDetailBlock(element)

root.ClaimantContact = ClaimantContact

jQuery ->
  new ClaimantContact( )

