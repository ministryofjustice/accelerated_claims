
class @EndTimer
  constructor: (minutesDelay, callback, date) ->
    date = new Date() if !date
    millisecondsDelay = (minutesDelay * 60 * 1000)
    @endTime = new Date( date.getTime() + millisecondsDelay )
    @intervalId = setInterval(( => @checkEndTimeReached() ), 1000)
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

