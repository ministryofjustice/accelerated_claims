$statsd = Statsd.new 'localhost', 8125

pdf_events_to_measure = ['generate.pdf',
                         'fill_form.pdf',
                         'add_defendant_two.pdf',
                         'strike_out_statements.pdf',
                         'add_strikes_via_cli.pdf',
                         'add_strikes_via_service.pdf',
                         'error_add_strikes_commandline.pdf',
                         'missing_file_add_strikes_commandline.pdf',
                         'store_strikes.pdf']

def reorder_namespace_for_statsd name
  # performing this reordering as statsd's namespacing is from:
  #   ---->
  # left to right
  #
  # and ActiveSupport::Notifications' is
  #   <----
  # right to left
  name.split('.').reverse.join('.')
end

def notify_of_duration name, start, finish
  label = reorder_namespace_for_statsd name
  duration_in_milliseconds = ((finish - start) * 1000).round
  $statsd.timing "#{label}", duration_in_milliseconds
end

pdf_events_to_measure.each do |event|
  ActiveSupport::Notifications.subscribe(event) do |name, start, finish|
    notify_of_duration name, start, finish
  end
end
