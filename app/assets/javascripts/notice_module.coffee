root = exports ? this

noticeServedNotCompleted = ->
  !(
    $('#claim_notice_notice_served_yes').is(":checked") ||
    $('#claim_notice_notice_served_no').is(":checked")
  )

noticeNotServed = ->
  $('#claim_notice_notice_served_no').is(":checked")

removeNoticeErrorLinks = ->
  errors = $('.error-link[data-id^="#claim_notice_"]')
  errorLocation = if errors.size() > 0
    errors.last().parent()
  else
    null

  errors.each ->
    $(this).remove()

  errorLocation

addErrorToNoticeSection = (errorLocation) ->
  if errorLocation
    $('#notice-module span.error').each ->
      $(this).remove()

    $('#notice-module .error').each ->
      $(this).removeClass('error')

    fieldset = $('#notice-module fieldset').first()
    fieldset.addClass('error')
    fieldset.attr('id','claim_notice_notice_served_error')

    message = 'You must say whether or not you gave notice to the defendant'
    $('#notice-module legend').first().append('<span class="error">' + message + '</span>')
    $(errorLocation).html('<a class="error-link" data-id="#claim_notice_notice_served_error" href="#claim_notice_notice_served_error">' + message + '</a>')

jQuery ->
  if noticeServedNotCompleted() || noticeNotServed()
    errorLocation = removeNoticeErrorLinks()
    addErrorToNoticeSection(errorLocation)

