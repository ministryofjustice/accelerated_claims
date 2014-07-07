module ZendeskHelper
  def self.send_to_zendesk(feedback, client=ZENDESK_CLIENT)
    if Rails.env.production? || Rails.env.development?
      ZendeskAPI::Ticket.create!(client, description: feedback.text,
        requester: { email: feedback.email_or_anonymous_placeholder, name: feedback.name_for_feedback  },
        custom_fields: [
         {id: '23730083', value: ''},
         {id: '23757677', value: 'civil_claims_accelerated'},
         {id: '23791776', value: feedback.user_agent}
       ])
    end
  end

  def self.callback_request(request, client=ZENDESK_CLIENT)
    if Rails.env.production? || Rails.env.development?
      ZendeskAPI::Ticket.create!(client, description: request.description,
        requester: { email: 'call-me@no-email.none', name: request.name },
        custom_fields: [
         { id: '23757677', value: 'civil_claims_accelerated' },
         { id: '24018396', value: request.phone }
       ])
    end
  end
end
