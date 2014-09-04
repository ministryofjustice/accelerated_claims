root = exports ? this

DefendantModule = 
  hideDefendantSections: ->
    console.log "HIDE ALL DEFENDANTS"
    $('.sub-panel.defendant').hide()


  showDefendants: (numberOfDefendants) ->
    console.log "SHOW DEFENDANTS"
    DefendantModule.hideDefendantSections()
    $('#num-defendants-error-message').hide()
    number = parseInt numberOfDefendants
    console.log "NUMBER IS #{number}"
    if number > 20
      $('#num-defendants-error-message').show()
    else
      if number > 0 and number < 21
        array = _.range(1, number + 1)
        _.each array, (i) ->
          id = "#defendant_#{i}_subpanel"
          console.log "SHOWING #{id}"
          $(id).show()


  bindToNumberDefendantsInput: ->
    $('#claim_num_defendants').on 'keyup', ->
      string = $(this).val()
      DefendantModule.showDefendants(string)



  setup: ->
    console.log "SETUP"
    DefendantModule.hideDefendantSections()
    DefendantModule.bindToNumberDefendantsInput()
    DefendantModule.showDefendants($('#claim_num_defendants').val())
    console.log "END OF SETUP"




root.DefendantModule = DefendantModule

jQuery ->
  DefendantModule.setup()



