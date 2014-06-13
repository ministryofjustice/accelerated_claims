root = exports ? this

class SessionTimeout
  constructor: (sessionMinutes, warnMinutesBeforeEnd) ->
    @sessionEndDelay = sessionMinutes * 60 * 1000
    @refreshSessionDelay = (sessionMinutes - warnMinutesBeforeEnd) * 60 * 1000

  startTimer: ->
    @sessionEndId =           window.setTimeout( @endSession ,           @sessionEndDelay)
    @refreshSessionDialogId = window.setTimeout( @refreshSessionDialog , @refreshSessionDelay)

  endSession: ->
    alert('end')

  refreshSessionDialog: ->
    alert('dialog')

root.SessionTimeout = SessionTimeout

