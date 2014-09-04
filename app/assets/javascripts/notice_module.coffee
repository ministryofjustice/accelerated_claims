root = exports ? this

noticeServedNotCompleted = ->
  !(
    $('#claim_notice_notice_served_yes').is(":checked") ||
    $('#claim_notice_notice_served_no').is(":checked")
  )

noticeNotServed = ->
  $('#claim_notice_notice_served_no').is(":checked")

removeSecondPageviewTrigger = ->
  $('#claim_notice_served_by_name').removeAttr('data-virtual-pageview')

removeNoticeErrorLinks = ->
  errors = $('.error-link[data-id^="#claim_notice_"]')

  errors.each ->
    unless $(this).attr('data-id') == '#claim_notice_notice_served_error'
      $(this).parent().remove()

jQuery ->
  removeSecondPageviewTrigger()

  if noticeServedNotCompleted() || noticeNotServed()
    removeNoticeErrorLinks()
