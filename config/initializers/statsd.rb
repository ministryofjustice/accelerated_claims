$statsd = Statsd.new 'localhost', 8125

events_to_measure = ['generate.pdf',
                     'add_defendant_two.pdf',
                     'strike_out_statements.pdf',
                     'add_strikes_service.pdf',
                     'store_strikes.pdf']

events_to_measure.each do |event|
  ActiveSupport::Notifications.subscribe(event) do |name, start, finish|
    name_for_statsd = name.split('.').reverse.join('.')
    duration_in_milliseconds = ((finish - start) * 1000).round
    $statsd.timing "#{name_for_statsd}", duration_in_milliseconds
  end
end
