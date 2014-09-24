//= require jasmine-jquery
//= require 'postcode_lookup'

describe 'PostcodeLookup', ->

  describe 'successful lookup', ->

    it 'should call displayAddresses on view', ->
      spyOn(jQuery, 'ajax').and.callFake (options) ->
        options.success('dummy')

      view = jasmine.createSpyObj('view', ['displayAddresses'])
      PostcodeLookup.lookup 'SW16AJ', view
      expect(view.displayAddresses).toHaveBeenCalledWith('dummy')


  describe 'lookup fails due to invalid postcode', ->
