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
    postcode = params['postcode']

    result = if ENV["ENV_NAME"] == "production"
               court_finder_lookup(postcode)
             else
               postcode == 'fake' ? [] : TEST_RESPONSE_DATA
             end

    if result.empty?
      message = "No court found for #{postcode} postcode"
      render json: message, status: :not_found
    else
      render json: result
    end
  end

  private

  def court_finder_lookup(postcode)
    output = Courtfinder::Client::HousingPossession.new.get(postcode)
    if output.key? :error
      LogStuff.error(:court_finder) { output[:error] }
      output = []
    end
    output
  end
end
