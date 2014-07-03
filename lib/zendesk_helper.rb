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
      # TODO: this needs to be done properly
      # I don't know what do custom fields stand for and I don't have
      # access to Zendesk instance we use to look it up!
      # ZendeskAPI::Ticket.create!(client, description: request.description,
      #   requester: { email: 'no-reply@fake-email.fakery', name: request.name },
      #   custom_fields: [
      #    {id: '23730083', value: ''},
      #    {id: '23757677', value: 'civil_claims_accelerated'},
      #    # {id: '23791776', value: feedback.user_agent}
      #  ])
    end
  end
end
