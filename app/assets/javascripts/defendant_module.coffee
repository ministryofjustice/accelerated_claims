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

#fixme refactor out
  showAddressIfStarted: (defendant_id) ->
    $id = $("#defendant_#{defendant_id}_resident_address")
    $link = $id.find('a.caption')
    add = $id.find('textarea').val()
    postcode = $id.find('input').val()

    # panel will be hidden by default
    if add!='' || postcode!=''
      $id.toggleClass( 'open' )

    if $id.hasClass( 'open' )
      $link.attr('aria-expanded','true')
    else
      $link.attr('aria-expanded','false')

  toggleAddress: ($area) ->
    # get parent
    $panel = $area.parents('div.sub-panel').first()
    # show hide panel
    $panel.toggleClass('open')
    # and link
    if $panel.hasClass( 'open' )
      $area.attr('aria-expanded','true')
    else
      $area.attr('aria-expanded','false')

  setup: ->
    DefendantModule.hideDefendantSections()
    DefendantModule.bindToNumberDefendantsInput()
    DefendantModule.bindToShowHideAddress()
    DefendantModule.showDefendants($('#claim_num_defendants').val())

root.DefendantModule = DefendantModule

jQuery ->
  DefendantModule.setup()

