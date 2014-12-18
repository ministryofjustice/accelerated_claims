root = exports ? this

FeeAccountModule =

  initialDisplay: ->
    detailsElements = $('details', $('#fee-section').parent() )
    root.expandBlockIfPopulated(detailsElements)

root.FeeAccountModule = FeeAccountModule

