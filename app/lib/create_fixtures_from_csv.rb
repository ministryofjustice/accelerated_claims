# Data source: 
# https://docs.google.com/a/digital.justice.gov.uk/spreadsheet/ccc?key=0Arsa0arziNdndHlwM2xJMVl5Z3pDdFVOYnVsRmZST1E&usp=sharing
# download as CSV
# copy to the same folder as this script
# rename as 'data.csv'

require 'csv'
require 'json'
require 'excon'

class DataScenarioGenerator
  def initialize(csv_filename)
    @rows = CSV.read(csv_filename)
    @rows.shift      # remove first row (test data disclaimer)
    @column_containing_first_journey = 3
    @scenario_data = buildDataHash
  end

  def writeToFile
    @scenario_data.each_with_index do |data, index|
      file = extract_filename(data)
      puts "Writing #{file}"
      File.open(file,'w') do |f|
        data = JSON.pretty_generate(data)
        data.gsub!(/"([^"]+)":/, '\1:')
        data.gsub!('null','nil')

        f.write data
      end
    end
  end

  def extract_filename(data)
    data[:title] =~ /^JOURNEY ([0-9]+)/
    journey_number = sprintf('%02d', $1.to_i)
    js_type = data[:javascript].downcase
    File.join(Rails.root, "spec", "fixtures", "scenario_#{journey_number}_#{js_type}_data.rb")
  end

  def sanitizeValue(model, attribute, value)
    value = nil if value == '-'

    if(model == 'property' && attribute == 'house')
      value = (!value.nil? && value.downcase == 'house') ? 'Yes' : 'No'
    end

    if attribute[/date/] && value
      begin
        value = Date.parse(value).strftime('%Y-%m-%d')
      rescue
        puts "Error at #{model}, #{attribute}"
        puts "can't parse #{value} to date"
      end
    end
    value
  end

  def buildDataHash
    scenarios = []
    beginning = @column_containing_first_journey
    ending = countScenarios + @column_containing_first_journey - 1
    beginning.upto(ending) do |index|
      scenarios << getScenario(index)
    end
    scenarios
  end

  def getScenario(index)
    scenario = {
      title: @rows[0][index],
      description: [@rows[1][index], @rows[2][index]],
      javascript: @rows[3][index],
      claim: {}
    }
    col = index + @column_containing_first_journey - 1
    validRows.each do |row|
      model = row[1]
      field = row[2]
      value = sanitizeValue(model, field, row[index])
      scenario[:claim][model.to_sym] ||= {}
      scenario[:claim][model.to_sym][field.to_sym] = value
    end
    scenario
  end

  def validRows
    valid_rows = []
    @rows.each.with_index do |r, index|
      if(index > 0 && !r[1].nil?)
        valid_rows << r
      end
    end
    valid_rows
  end

  def countScenarios
    r = @rows[0] 
    col = @column_containing_first_journey 
    count = 0 
    while(r[col] != nil) do
      count += 1
      col += 1
    end
    @scenario_count = count
  end
end

class DownloadScenarioData
  def self.download
    url = get_download_url
    puts "Downloading: #{url}"

    begin
      response = Excon.get(url, {
        headers: {
          "Accept" => "text/csv"
        },
        expects: [200],
      })
      write_csv_to_tempfile response.body
    rescue
      puts 'Error downloading spreadsheet, loading local copy'
      file_path = Rails.root.join('lib', 'assets', 'source_data.csv')
      file_path
    end
  end

  def self.write_csv_to_tempfile(csv_data)
    file = Tempfile.new('data_csv', encoding: 'utf-8')
    file.write(csv_data)
    file.path
  end

  # TODO replace this temprorary URl with real one once testing done
  def self.get_download_url
    key = "0Arsa0arziNdndHlwM2xJMVl5Z3pDdFVOYnVsRmZST1E"
    "https://docs.google.com/spreadsheet/pub?key=#{key}&single=true&gid=0&output=csv"
  end
end