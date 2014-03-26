# Assumes you have extracted journey's data sheet to...

require 'csv'
require 'pry'
require 'json'

rows = CSV.read('data.csv')

scenarios = []

3.upto(11) do |index|
  scenarios[index - 3] = { 'claim' => {} }
  hash = scenarios[index - 3]['claim']

  by_model = rows.group_by{|x| x[1]}
  by_model.each do |model, attributes|
    if model
      hash[model] ||={}

      attributes.group_by {|x| x[2]}.each do |attribute, values|
        if attribute
          value = values.first[index]

          if attribute[/date/] && value
            begin
              value = Date.parse(value)
            rescue
              puts "can't parse #{value} to date"
            end
          end
          hash[model][attribute] = value
        end
      end
    end
  end
end

descriptions = [
  ['JOURNEY 1', 'Husband and wife, renting a property through a rental agency', '2 claimants living together, 2 defendants living in the property, rental agency'],
  ['JOURNEY 2', 'Middle aged professional with large portfolio including a student house needs to kick out a difficult tenant', '1 claimant, 1 defendant living in the property, part of a house, litigant in person'],
  ['JOURNEY 3', 'Solicitor acting on behalf of an elder gentleman. Tenants speak little English and communication has been poor.', 'Solicitor for 1 claimant, 2 defendants living in the property'],
  ['JOURNEY 4', 'Young professional submitting the claim on his own, multiple tenancy agreements, bought a new house with a tenant in there', '1 claimant, 1 defendant living in the property, multiple tenancy agreements, litigant in person'],
  ['JOURNEY 5', 'Local authority evicting a demoted tenant', '1 claimant, 1 defendant, organisation litigant in person'],
  ['JOURNEY 6', 'Housing association evicting a tenant', '1 organisation claimant, 1 defendant'],
  ['JOURNEY 7', 'Young unmarried couple joint own property. Two tenants who were a couple but broke up and 1 has moved out. Both stopped paying rent', '2 claimants, 2 defendants, 1 not living in the property, unknown forwarding address'],
  ['JOURNEY 8', 'Elder welsh lady, using a solictor to evict 2 young men on benefits', 'Solicitor for 1 claimant, 2 defendants living in the property'],
  ['JOURNEY 9', 'Two mates living apart joint own a property, tenant is now living at a mates house and the property is abandoned', '2 claimants, 1 defendant, not living in the property, known forwarding address']
]

scenarios.each_with_index do |data, index|
  File.open("spec/fixtures/scenario_#{index + 1}_data.rb",'w') do |f|
    description = descriptions[index].map{|x| '# ' + x}.join("\n")
    data = JSON.pretty_generate(data)
    data.gsub!(/"([^"]+)":/, '\1:')
    data.gsub!('null','nil')

    f.write [description, data].join("\n")
  end
end
