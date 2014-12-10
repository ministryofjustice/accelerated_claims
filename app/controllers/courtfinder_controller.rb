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

    court = if ENV['ENV_NAME'] == 'production'
               court_finder_lookup(postcode)
             else
               postcode == 'fake' ? [] : TEST_RESPONSE_DATA
             end

    if court.empty?
      message = "No court found for #{postcode} postcode"
      render json: message, status: :not_found
    else
      render json: court
    end
  end

  private

  def court_finder_lookup(postcode)
    court = Courtfinder::Client::HousingPossession.new.get(postcode)

    begin
      if court.key? :error
        LogStuff.error(:court_finder) { court[:error] }
        court = []
      end
    rescue NoMethodError
      court = []
    end
    court
  end
end
