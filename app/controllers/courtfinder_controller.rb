require 'courtfinder/client'

class CourtfinderController < ApplicationController

  TEST_RESPONSE_DATA = [{
    'name' => 'Cambridge County Court and Family Court',
    'address' => {
      'town' => 'Cambridge',
      'address_lines' => ['Cambridge County Court and Family Court Hearing Centre',
                         '197 East Road'],
      'type' => 'Postal',
      'postcode' => 'CB1 1BA',
      'county' => 'Cambridgeshire'
    }
  }]

  def address
    result = if ENV["ENV_NAME"] == "production"
                # Courtfinder::Client::HousingPossession.new.get(params['postcode'])
               []
             else
               TEST_RESPONSE_DATA
             end

    if result.empty?
      message = "No court found for #{params['postcode']} postcode"
      render json: message, status: :not_found
    else
      render json: result
    end
  end
end
