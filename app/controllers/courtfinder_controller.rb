require 'courtfinder/client'

class CourtfinderController < ApplicationController
  def address
    postcode = params['postcode']

    court = Courtfinder::Client::HousingPossession.new.get(params['postcode'])

    if court.nil? || court.empty?
      message = "No court found for #{postcode} postcode"
      render json: message, status: :not_found
    else
      render json: (process_court_data court)
    end
  end

  private

  def process_court_data(court)
    unless court.instance_of? Array
      if court.key? 'error'
        LogStuff.error(:court_finder) { court['error'] }
        court = []
      end
    end
    court
  end
end
