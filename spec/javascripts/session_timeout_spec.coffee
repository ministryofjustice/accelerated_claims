//= require jquery
//= require jasmine-jquery
//= require session_timeout

describe 'SessionTimeout', ->

  beforeEach ->
    jasmine.Clock.useMock()

    @timeout = new window.SessionTimeout(2/60, 1/60)
    @sessionEndDelay = 2000
    @refreshSessionDelay = 1000

  describe 'on construction', ->
    it 'sets delay times correctly', ->
      expect(@timeout.sessionEndDelay).toEqual @sessionEndDelay
      expect(@timeout.refreshSessionDelay).toEqual @refreshSessionDelay

  describe 'refresh session dialog', ->

    it 'is not shown before configured time', ->
      spyOn @timeout, 'refreshSessionDialog'
      @timeout.startTimer()
      jasmine.Clock.tick(@refreshSessionDelay - 1)
      expect(@timeout.refreshSessionDialog).not.toHaveBeenCalled()

    it 'is shown after configured time', ->
      spyOn @timeout, 'refreshSessionDialog'
      @timeout.startTimer()
      jasmine.Clock.tick(@refreshSessionDelay)
      expect(@timeout.refreshSessionDialog).toHaveBeenCalled()

  describe 'session without session refresh', ->

    it 'is not ended before configured time', ->
      spyOn @timeout, 'endSession'
      @timeout.startTimer()
      jasmine.Clock.tick(@sessionEndDelay - 1)
      expect(@timeout.endSession).not.toHaveBeenCalled()

    it 'is ended after configured time', ->
      spyOn @timeout, 'endSession'
      @timeout.startTimer()
      jasmine.Clock.tick(@sessionEndDelay)
      expect(@timeout.endSession).toHaveBeenCalled()


