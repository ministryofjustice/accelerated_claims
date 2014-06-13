root = exports ? this

class SessionTimeout
  constructor: (sessionMinutes, warnMinutesBeforeEnd) ->
    @sessionEndDelay = sessionMinutes * 60 * 1000
    @refreshSessionDelay = (sessionMinutes - warnMinutesBeforeEnd) * 60 * 1000

  startTimer: ->
    @sessionTimeoutId = window.setTimeout( @endSession, @sessionEndDelay )
    window.setTimeout( @refreshSessionDialog, @refreshSessionDelay )

  endSession: ->
    alert('session expired')
    window.setTimeout( (->window.location = '/heartbeat'), 500)

  refreshSessionDialog: =>
    moj.Modules.sessionModal.showModal( @refreshSession )

  refreshSession: =>
    window.clearTimeout(@sessionTimeoutId);
    $.get( '/heartbeat', ( =>
      alert('heartbeat success!')
      @startTimer()
    ) )


root.SessionTimeout = SessionTimeout

jQuery ->
  sessionMinutes = 4/60 # 60
  warnMinutesBeforeEnd = 57/60 # 15
  timeout = new root.SessionTimeout(sessionMinutes, warnMinutesBeforeEnd)
  timeout.startTimer()
