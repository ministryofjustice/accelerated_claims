//= require jquery
//= require jasmine-jquery
//= require timer

describe 'EndTimer', ->

  beforeEach ->
    jasmine.clock().install()
    @startTime = new Date(2013, 9, 23, 10, 32, 21)
    @minutes = 60
    @foo = bar: () ->
    @bar = foo: () ->
    @timer = new window.EndTimer(@foo.bar, @minutes, @startTime)

  afterEach ->
    jasmine.clock().uninstall()

  describe 'test Date mock', ->
    it 'mocks ticks correctly', ->
      jasmine.clock().mockDate(@startTime)
      jasmine.clock().tick(50)
      expect(new Date().getTime()).toEqual(@startTime.getTime() + 50)

  describe 'on initialisation with start date and duration in minutes', ->
    it 'set end time is set correctly', ->
      expect( @timer.endTime.getTime() ).toEqual( @startTime.getTime() + (@minutes * 60 * 1000) )

  describe 'after 999 ms', ->
    it 'has not checked if end time is reached', ->
      spyOn @timer, 'checkEndTimeReached'
      jasmine.clock().tick(999)
      expect(@timer.checkEndTimeReached).not.toHaveBeenCalled()

    it 'has not called seconds callback', ->
      spyOn @bar, 'foo'
      @timer = new window.EndTimer(@foo.bar, @minutes, @startTime, @bar.foo)
      jasmine.clock().tick(999)
      expect(@bar.foo).not.toHaveBeenCalled()

    describe 'milliseconds left', ->
      it 'should be correct', ->
        jasmine.clock().mockDate(@startTime)
        jasmine.clock().tick(999)
        expect(@timer.millisecondsLeft()).toEqual( (60 * 60 * 1000) - 999 )

  describe 'after 1000 ms', ->
    it 'checks if end time is reached', ->
      spyOn @timer, 'checkEndTimeReached'
      jasmine.clock().tick(1000)
      expect(@timer.checkEndTimeReached).toHaveBeenCalled()

    it 'calls seconds callback', ->
      spyOn @bar, 'foo'
      @timer = new window.EndTimer(@foo.bar, @minutes, @startTime, @bar.foo)
      jasmine.clock().tick(1000)
      expect(@bar.foo).toHaveBeenCalled()

    describe 'milliseconds left', ->
      it 'should be correct', ->
        jasmine.clock().mockDate(@startTime)
        jasmine.clock().tick(1000)
        expect(@timer.millisecondsLeft()).toEqual( (60 * 60 * 1000) - 1000 )

    describe 'when stopTimer() called before 100 ms', ->
      it 'does not check if end time is reached', ->
        spyOn @timer, 'checkEndTimeReached'
        jasmine.clock().tick(999)
        @timer.stopTimer()
        jasmine.clock().tick(1)
        expect(@timer.checkEndTimeReached).not.toHaveBeenCalled()

  describe 'after 60 minutes', ->
    it 'triggers end', ->
      spyOn @timer, 'triggerEnd'
      jasmine.clock().tick(60 * 1000)
      expect(@timer.triggerEnd).toHaveBeenCalled()

    it 'stops timer', ->
      spyOn @timer, 'stopTimer'
      jasmine.clock().tick(60 * 1000)
      expect(@timer.stopTimer).toHaveBeenCalled()

  describe 'stopTimer()', ->
    it 'clears interval timer', ->
      spyOn window, 'clearInterval'
      @timer.stopTimer()
      expect(window.clearInterval).toHaveBeenCalled()

  describe 'triggerEnd()', ->
    it 'calls callback function', ->
      spyOn(@foo, 'bar')
      @timer = new window.EndTimer(@foo.bar, @minutes, @startTime)
      @timer.triggerEnd()
      expect(@foo.bar).toHaveBeenCalled()
