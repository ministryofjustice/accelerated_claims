root = exports ? this

class SessionTimeout
  constructor: (sessionMinutes, warnMinutesBeforeEnd) ->
    @sessionEndDelay = sessionMinutes * 60 * 1000
    @refreshSessionDelay = (sessionMinutes - warnMinutesBeforeEnd) * 60 * 1000

  startTimer: ->
    @sessionTimeoutId = window.setTimeout( @endSession, @sessionEndDelay )
    window.setTimeout( @refreshSessionDialog, @refreshSessionDelay )

  endSession: ->
    # alert('session expired')
    $.ajax
      type: "get"
      url: "/expire_session?redirect=false"
      success: (data, textStatus, jqXHR) ->
        moj.log textStatus
        document.location.href = "/expired"
        return

      error: (jqXHR, textStatus, errorThrown) ->
        moj.log "error"
        moj.log jqXHR
        moj.log textStatus
        moj.log errorThrown
        return

    # window.setTimeout( (->window.location = '/heartbeat'), 500)

  refreshSessionDialog: =>
    moj.Modules.sessionModal.showModal( @refreshSession )

  refreshSession: =>
    window.clearTimeout(@sessionTimeoutId);
    $.get( '/heartbeat', ( =>
      # alert('heartbeat success!')
      @startTimer()
    ) )


root.SessionTimeout = SessionTimeout

jQuery ->
  sessionMinutes = 0.2 # 60
  warnMinutesBeforeEnd = 0.1 # 15
  timeout = new root.SessionTimeout(sessionMinutes, warnMinutesBeforeEnd)
  timeout.startTimer()
