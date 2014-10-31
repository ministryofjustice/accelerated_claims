root = exports ? this

ShowHideModule =

  bindToShowHidePanel: ->
    $('.show-hide-panel').on 'click', ->
      ShowHideModule.togglePanel($(this))

  togglePanel: (link) ->
    panel = link.parents('div.sub-panel').first()
    panel.toggleClass('open')
    if panel.hasClass( 'open' )
      link.attr('aria-expanded','true')
      panel.find('input, textarea').first().focus()
    else
      link.attr('aria-expanded','false')
    false

  setup: ->
    ShowHideModule.bindToShowHidePanel()

root.ShowHideModule = ShowHideModule

jQuery ->
  ShowHideModule.setup()
