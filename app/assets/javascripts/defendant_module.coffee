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

  bindToNumberDefendantsInput: ->
    $('#claim_num_defendants').on 'keyup', ->
      string = $(this).val()
      DefendantModule.showDefendants(string)

  setup: ->
    DefendantModule.hideDefendantSections()
    DefendantModule.bindToNumberDefendantsInput()
    DefendantModule.showDefendants($('#claim_num_defendants').val())

    detailsElements = $('details', $('#defendants') )
    root.expandBlockIfPopulated(detailsElements)

root.DefendantModule = DefendantModule

jQuery ->
  DefendantModule.setup()

