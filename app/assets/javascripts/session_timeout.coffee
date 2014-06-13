root = exports ? this

class SessionTimeout
  constructor: (sessionMinutes, warnMinutesBeforeEnd) ->
    @sessionEndDelay = sessionMinutes * 60 * 1000
    @refreshSessionDelay = (sessionMinutes - warnMinutesBeforeEnd) * 60 * 1000

  startTimer: ->
    @sessionTimeoutId = window.setTimeout( @endSession ,           @sessionEndDelay)
    window.setTimeout( @refreshSessionDialog , @refreshSessionDelay)

  endSession: ->
    alert('end')

  refreshSessionDialog: ->
    alert('dialog')

  refreshSession: ->
    window.clearTimeout(@sessionTimeoutId);
    @startTimer();


root.SessionTimeout = SessionTimeout

