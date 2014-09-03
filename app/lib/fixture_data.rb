require 'create_fixtures_from_csv'

class FixtureData
  class << self
    def data(reload = false)
      if reload
        # Note that it can take a minute for the CSV file from google to update
        @data = FixtureData.new
      else
        @data ||= FixtureData.new
      end
    end
  end

  def initialize
    raw_data = DownloadScenarioData.download
    @data = DataScenarioGenerator.new(raw_data).buildDataHash.freeze
  end

  def params_data_for(index)
    # Index journeys from 1
    journey = @data[index - 1]

    unless journey
      return HashWithIndifferentAccess.new({
        property: {
          street: "No journey with that ID",
        }
        })
    end

    claim = replace_dates_with_form_style_dates(journey[:claim])

    # Move claim model data to top level
    claim_model_data = claim.delete(:claim)
    claim = claim.merge(claim_model_data)

    return HashWithIndifferentAccess.new(claim)
  end

  private

  # Recursively build a hash, naively converting any keys containing the string
  # date to rails date helper style
  def replace_dates_with_form_style_dates(hash, new_hash = {})
    hash.each do |k,v|
      if v.kind_of?(Hash)
        new_hash[k] = replace_dates_with_form_style_dates(v)
      else
          if (k[/_date/] || k[/date_/]) && v != nil
          new_hash = new_hash.merge(form_date(k, v))
        else
          new_hash[k] = v
        end
      end
    end
    return new_hash
  end

  def form_date(field, date_string)
    date = Date.parse(date_string)
    {
      "#{field}(3i)" => date.try(:day),
      "#{field}(2i)" => date.try(:month),
      "#{field}(1i)" => date.try(:year),
    }
  end
end
