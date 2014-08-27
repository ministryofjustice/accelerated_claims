root = exports ? this

class EndTimer
  constructor: (endCallback, minutesDelay, now, secondsCallback) ->
    now = new Date() if !now
    millisecondsDelay = (minutesDelay * 60 * 1000)
    @endTime = new Date( now.getTime() + millisecondsDelay )
    @secondsCallback = secondsCallback
    checkFunction = ( =>
      if @secondsCallback
        timeLeft = @millisecondsLeft()
        @secondsCallback(timeLeft)

      @checkEndTimeReached()
    )
    @intervalId = setInterval(checkFunction, 1000)
    @endCallback = endCallback

  checkEndTimeReached: ->
    now = new Date()
    if now >= @endTime
      @stopTimer()
      @triggerEnd()

  stopTimer: ->
    clearInterval(@intervalId)

  triggerEnd: ->
    @endCallback()

  millisecondsLeft: ->
    @endTime - new Date()

root.EndTimer = EndTimer
