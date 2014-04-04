# Assumes you have extracted journey's data sheet to...

require 'csv'
require 'pry'
require 'json'

class DataScenarioGenerator
  def initialize(csv_filename='data.csv')
    @rows = CSV.read(csv_filename)
    @column_containing_first_journey = 3
    @scenario_data = buildDataHash
  end

  def writeToFile
    @scenario_data.each_with_index do |data, index|
      file = File.expand_path("../scenario_#{index + 1}_data.rb", __FILE__)

      File.open(file,'w') do |f|
        data = JSON.pretty_generate(data)
        data.gsub!(/"([^"]+)":/, '\1:')
        data.gsub!('null','nil')

        f.write data
      end
    end
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

d = DataScenarioGenerator.new('data.csv')
d.writeToFile




