root = exports ? this

FeeAccountModule =

  initialDisplay: ->
    panel = $('#fee-account-panel')
    link = $('#fee-account')
    if $('#claim_fee_account').val()!=''
      ShowHideModule.togglePanel(link)

  setup: ->
    FeeAccountModule.initialDisplay()

root.FeeAccountModule = FeeAccountModule

jQuery ->
  FeeAccountModule.setup()
