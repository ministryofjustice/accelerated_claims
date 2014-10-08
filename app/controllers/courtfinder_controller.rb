require 'courtfinder/client'

class CourtfinderController < ApplicationController
  def address
    result = Courtfinder::Client::HousingPossession.new.get(params['postcode'])

    if result.empty?
      render json: "No court found for #{params['postcode']} postcode", \
             status: :not_found
    else
      render json: result
    end
  end
end
