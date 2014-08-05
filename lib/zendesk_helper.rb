module ZendeskHelper

  def self.send_feedback(feedback, client=ZENDESK_CLIENT)
    if Rails.env.production? || Rails.env.development?
      ZendeskAPI::Ticket.create!(client,
        description: feedback.text,
        requester: {
          email: feedback.email_or_anonymous_placeholder,
          name: feedback.name_for_feedback
        },
        custom_fields: [
         {id: '23730083', value: ''},
         {id: '23757677', value: 'civil_claims_accelerated'},
         {id: '23791776', value: feedback.user_agent}
       ])
    end
  end

  def self.callback_request(request, client=ZENDESK_CLIENT)
    if Rails.env.production? || Rails.env.development?
      msg = " has requested assistance, please call them back on: "
      ZendeskAPI::Ticket.create!(client,
        description: "#{request.name} #{msg} #{request.phone}\n\n\n#{request.description}",
        requester: { email: 'phone-me@no-email.none', name: 'Civil Claims AD' },
        custom_fields: [
          { id: '23757677', value: 'civil_claims_accelerated_callback' },
          { id: '24041286', value: request.phone }
        ])
    end
  end
end
