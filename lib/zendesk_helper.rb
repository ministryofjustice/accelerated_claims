module ZendeskHelper
  def self.send_to_zendesk(feedback, client=ZENDESK_CLIENT)
    if Rails.env.production? || Rails.env.development?
      ZendeskAPI::Ticket.create!(client, description: feedback.text, requester: { email: feedback.email, name: 'Unknown' }, custom_fields: [
         {id: '23730083', value: feedback.referrer},
         {id: '23757677', value: 'civil_claims_accelerated'},
         {id: '23791776', value: feedback.user_agent}
       ])
    end
  end
end
