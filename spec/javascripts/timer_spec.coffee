//= require jquery
//= require jasmine-jquery
//= require timer

describe 'EndTimer', ->

  beforeEach ->
    jasmine.clock().install()
    @start = new Date(2013, 9, 23)
    @minutes = 60
    @foo = bar: () ->
    @timer = new window.EndTimer(@minutes, @foo.bar, @start)

  afterEach ->
    jasmine.clock().uninstall()

  describe 'test Date mock', ->
    it 'mocks ticks correctly', ->
      jasmine.clock().mockDate(@start)
      jasmine.clock().tick(50)
      expect(new Date().getTime()).toEqual(@start.getTime() + 50)

  describe 'on initialisation with start date and duration in minutes', ->
    it 'set end time is set correctly', ->
      expect( @timer.endTime.getTime() ).toEqual( @start.getTime() + (@minutes * 60 * 1000) )

  describe 'after 999 ms', ->
    it 'has not checked if end time is reached', ->
      spyOn @timer, 'checkEndTimeReached'
      jasmine.clock().tick(999)
      expect(@timer.checkEndTimeReached).not.toHaveBeenCalled()

  describe 'after 1000 ms', ->
    it 'checks if end time is reached', ->
      spyOn @timer, 'checkEndTimeReached'
      jasmine.clock().tick(1000)
      expect(@timer.checkEndTimeReached).toHaveBeenCalled()

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
      @timer = new window.EndTimer(@minutes, @foo.bar, @start)
      @timer.triggerEnd()
      expect(@foo.bar).toHaveBeenCalled()
