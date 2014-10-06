require 'courtfinder/client'

class CourtfinderController < ApplicationController
  def address
    client = Courtfinder::Client::HousingPossession.new

    begin
      render json: client.get(params["postcode"])
    rescue JSON::ParserError
      render json: "No court found for #{params["postcode"]} postcode", status: :not_found
    end
  end
end
