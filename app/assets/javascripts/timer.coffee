root = exports ? this

class EndTimer
  constructor: (callback, minutesDelay, now) ->
    now = new Date() if !now
    millisecondsDelay = (minutesDelay * 60 * 1000)
    @endTime = new Date( now.getTime() + millisecondsDelay )
    checkFunction = ( => @checkEndTimeReached() )
    @intervalId = setInterval(checkFunction, 1000)
    @callback = callback

  checkEndTimeReached: ->
    now = new Date()
    if now >= @endTime
      @stopTimer()
      @triggerEnd()

  stopTimer: ->
    clearInterval(@intervalId)

  triggerEnd: ->
    @callback()

  millisecondsLeft: ->
    @endTime - new Date()

root.EndTimer = EndTimer
