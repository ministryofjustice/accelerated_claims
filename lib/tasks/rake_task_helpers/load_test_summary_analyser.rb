require 'pp'
require 'csv'

class LoadTestSummaryAnalyser

  def initialize(filename)
    @filename = filename
    @records = []
  end

  def summarize(load_test_type)
    case load_test_type
    when 'response'
      summarize_response
    when 'breakpoint'
      summarize_breakpoint
    else
      raise "Invalid load test type: #{load_test_type.inspect}"
    end
  end

  def summarize_response
    load_summary_records
    minimum = @records.map{ |x| x[3].to_f }.min
    maximum = @records.map{ |x| x[4].to_f }.max
    average = @records.map{ |x| x[5].to_f }.inject{ |sum, el| sum + el }.to_f / @records.size
    { minimum: minimum, average: average, maximum: maximum}
  end

  def summarize_breakpoint
    load_summary_records
    pp @records
    puts "++++++ DEBUG notice ++++++ #{__FILE__}::#{__LINE__} ++++\n"
    puts 'Summarizing breakpoint'
    truncate_records_at_first_error
  end

  def load_summary_records
    CSV.foreach(@filename) do |row|
      @records << row unless row.first == 'elapsed_time'
    end
  end

  def truncate_records_at_first_error
  end
end

