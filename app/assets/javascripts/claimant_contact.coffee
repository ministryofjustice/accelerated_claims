root = exports ? this

class ClaimantContact
  constructor: () ->
    @claimantContactPanel = $('#claimant-contact')

    @referenceBlock = $('#reference-block')

    @buttonIndividual = $('#claim_claimant_type_individual')
    @buttonOrganization = $('#claim_claimant_type_organization')
    @numberOfClaimants = $('#claim_num_claimants')

    @hideContactPanel()
    @displayOnLoad()

    @buttonOrganization.on 'click', =>
      @showContactPanel()
      @referenceBlock.show()

    @buttonIndividual.on 'click', =>
      @showHideContactPanelDependingOnNumClaimants()

    $('#claim_num_claimants').on 'keyup', =>
      @showHideContactPanelDependingOnNumClaimants()

  showContactPanel: =>
    @claimantContactPanel.show()

  hideContactPanel: =>
    @claimantContactPanel.hide()

  organization: =>
    @buttonOrganization.is(':checked')

  individual: =>
    @buttonIndividual.is(':checked')

  displayOnLoad: =>
    if @organization()
      @showContactPanel()
    else if @individual()
      @showHideContactPanelDependingOnNumClaimants()

    detailsElements = $('details', $('#claimant-contact'))
    detailsElements.each (index) =>
      @expandBlockIfPopulated( detailsElements.eq(index) )

  showHideContactPanelDependingOnNumClaimants: =>
    if parseInt(@numberOfClaimants.val()) < 1 || @numberOfClaimants.val() == ""
      @hideContactPanel()
    else
      @showContactPanel()
      @referenceBlock.hide() unless @organization()

  expandBlockIfPopulated: (details) =>
    if details.is(':visible')
      userEnteredData = details.find( '[type="text"], textarea' ).filter( -> $(this).val() != '').length > 0
      if userEnteredData
        # use setTimeout() as details.polyfill.js may not be loaded yet
        setTimeout( (-> details.find('summary').trigger('click') ), 0)

root.ClaimantContact = ClaimantContact

root.expandBlockIfPopulated = root.ClaimantContact.prototype.expandBlockIfPopulated

