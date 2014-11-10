root = exports ? this

DefendantModule =
  hideDefendantSections: ->
    $('.sub-panel.defendant').hide()

  showDefendants: (numberOfDefendants) ->
    DefendantModule.hideDefendantSections()
    $('#num-defendants-error-message').hide()
    number = parseInt numberOfDefendants
    if number > 20
      $('#num-defendants-error-message').show()
    else
      if number > 0 and number < 21
        array = _.range(1, number + 1)
        _.each array, (i) ->
          id = "#defendant_#{i}_subpanel"
          $(id).show()
          DefendantModule.showAddressIfStarted(i)

  bindToNumberDefendantsInput: ->
    $('#claim_num_defendants').on 'keyup', ->
      string = $(this).val()
      DefendantModule.showDefendants(string)

  bindToShowHideAddress: ->
    $('.show-hide').on 'click', ->
      DefendantModule.toggleAddress($(this))

  showAddressIfStarted: (defendant_id) ->
    panel = $("#defendant_#{defendant_id}_resident_address")
    link = panel.find('a.caption')
    address = panel.find('textarea').val()
    postcode = panel.find('input').val()
    inhabits_property = $("#claim_defendant_#{defendant_id}_inhabits_property").val()
    if (address!='' || postcode!='') && inhabits_property=='no'
      panel.toggleClass( 'open' )
    DefendantModule.toggleAddressDisplay(panel, link)

  toggleAddress: (link) ->
    panel = link.parents('div.sub-panel').first()
    panel.toggleClass('open')
    DefendantModule.toggleAddressDisplay(panel, link)

  toggleAddressDisplay: (panel, link) ->
    pcp = panel.find('.postcode-picker-container').first()
    if panel.hasClass( 'open' )
      link.attr('aria-expanded','true')
      pcp.addClass('show').removeClass('hide')
    else
      link.attr('aria-expanded','false')
      pcp.addClass('hide').removeClass('show')

  setup: ->
    DefendantModule.hideDefendantSections()
    DefendantModule.bindToNumberDefendantsInput()
    DefendantModule.bindToShowHideAddress()
    DefendantModule.showDefendants($('#claim_num_defendants').val())

root.DefendantModule = DefendantModule

jQuery ->
  DefendantModule.setup()

