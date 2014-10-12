//= require underscore
//= require jquery
//= require jasmine-jquery
//= require defendant_module

expectSubpanelsVisible = (num_visible_subpanels) ->
  if num_visible_subpanels == 0
    visible_subpanels = [ 0 ]
    hidden_subpanels = [ 1 .. 20 ]
  else
    if num_visible_subpanels == 20
      visible_subpanels = [ 20 ]
      hidden_subpanels = [ 0 ]
    else
      visible_subpanels = [ 1 .. num_visible_subpanels ]
      hidden_subpanels = [ num_visible_subpanels + 1 ..  20 ]

  checkVisible(panel) for panel in visible_subpanels
  checkHidden(panel) for panel in hidden_subpanels

checkVisible = (panel_number) ->
  unless panel_number == 0
    element = $("#defendant_#{panel_number}_subpanel")[0]
    x = expect(element).toBeVisible()

checkHidden = (panel_number) ->
  unless panel_number == 0
    element = $("#defendant_#{panel_number}_subpanel")[0]
    expect(element).toBeHidden()

describe 'DefendantModule', ->
  element = null

  beforeEach ->
    element = $(
      '<input id="claim_num_defendants" name="claim[num_defendants]" type="text"></input>' +
      '<div id="defendant_1_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_2_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_3_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_4_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_5_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_6_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_7_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_8_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_9_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_10_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_11_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_12_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_13_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_14_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_15_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_16_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_17_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_18_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_19_subpanel" class="sub-panel defendant">AAAA</div>' +
      '<div id="defendant_20_subpanel" class="sub-panel defendant">AAAA</div>'
    )
    $(document.body).append(element)
    window.DefendantModule.setup()

  afterEach ->
    element.remove()
    element = null

  describe 'setup', ->
    describe 'when there is no value in num_defendants', ->
      it 'hides all sub-panel defendant sections', ->
        expectSubpanelsVisible(0)

    describe 'when there is the value 5 in num_defendants', ->
      it 'displays the first two defendant sections', ->
        $('#claim_num_defendants').val('5')
        window.DefendantModule.setup()
        expectSubpanelsVisible(5)

    describe 'when there is the value 20 in num_defendants', ->
      it 'displays the first two defendant sections', ->
        $('#claim_num_defendants').val('20')
        window.DefendantModule.setup()
        expectSubpanelsVisible(20)

  describe 'showDefendants', ->
    describe 'called with 2', ->
      it 'shows first two claimant sections', ->
        window.DefendantModule.showDefendants('2')
        expectSubpanelsVisible(2)

    describe 'called with 21', ->
      it 'should unhide the error message', ->
        html = $(
               '<input id="claim_num_claimants" name="claim[num_claimants]" type="text"></input>' +
               '<span class="error hide" id="num-defendants-error-message" style="display: inline;">XXXXX</span>'
        )
        $(document.body).append(html)
        window.DefendantModule.showDefendants('21')
        errorMessage = $('#num-defendants-error-message')
        expect(errorMessage).toBeVisible()

    describe 'called with 1 after 3', ->
      it 'shows just one defendant', ->
        window.DefendantModule.showDefendants('3')
        expectSubpanelsVisible(3)

        window.window.DefendantModule.showDefendants('1')
        expectSubpanelsVisible(1)
