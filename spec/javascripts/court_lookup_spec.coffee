//= require 'jasmine-jquery'
//= require 'court_lookup'

describe 'CourtLookup', ->

  describe 'successful lookup', ->

    it 'should call populateCourtDetails on view', ->
      spyOn(jQuery, 'ajax').and.callFake (url, options) ->
        options.success('dummy')

      view = jasmine.createSpyObj('view', ['populateCourtDetails'])
      CourtLookup.lookup 'SW16AJ', view
      expect(view.populateCourtDetails).toHaveBeenCalledWith()

  describe 'lookup fails', ->
    it 'should call displayNoResultsFound on view', ->
      spyOn(jQuery, 'ajax').and.callFake (url, options) ->
        options.error('xhr','status','error')

      view = jasmine.createSpyObj('view', ['displayNoResultsFound'])
      CourtLookup.lookup 'SW16AJ', view
      expect(view.displayNoResultsFound).toHaveBeenCalled()
