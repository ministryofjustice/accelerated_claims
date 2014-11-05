//= require 'jasmine-jquery'
//= require 'postcode_lookup'

testViewCallback = (view, statusCode, callback) ->
  spyOn(jQuery, 'ajax').and.callFake (url, options) ->
    options.statusCode[statusCode]()

  PostcodeLookup.lookup 'SW16AJ', 'all', view
  expect(callback).toHaveBeenCalled()


describe 'PostcodeLookup', ->

  describe 'successful lookup', ->

    it 'should call displayAddresses on view', ->
      spyOn(jQuery, 'ajax').and.callFake (url, options) ->
        options.success('dummy')

      view = jasmine.createSpyObj('view', ['displayAddresses'])
      PostcodeLookup.lookup 'SW16AJ', 'all', view
      expect(view.displayAddresses).toHaveBeenCalledWith('dummy')


  describe 'lookup fails due to invalid postcode', ->
    it 'should call displayInvalidPostcodeMessage on view', ->
      view = jasmine.createSpyObj('view', ['displayInvalidPostcodeMessage'])

      testViewCallback view, '422', view.displayInvalidPostcodeMessage

  describe 'lookup fails due to no results', ->
    it 'should call displayNoResultsFound on view', ->
      view = jasmine.createSpyObj('view', ['displayNoResultsFound'])

      testViewCallback view, '404', view.displayNoResultsFound

  describe 'lookup fails due to service unavailable', ->
    it 'should call displayServiceUnavailable on view', ->
      view = jasmine.createSpyObj('view', ['displayServiceUnavailable'])

      testViewCallback view, '503', view.displayServiceUnavailable
