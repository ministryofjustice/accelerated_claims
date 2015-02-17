class PDFDocument

  attr_reader :json

  def initialize(json, flatten=true)
    @json = json
    @flatten = flatten
    remove_backslash_r!
    reverse_possession_hearing!
    add_document_count
    add_checklist
  end

  def fill
    result_pdf = nil

    ActiveSupport::Notifications.instrument('generate.pdf') do
      begin
        template = File.join Rails.root, 'templates', 'form.pdf'
        result_pdf = Tempfile.new('accelerated_claim', '/tmp/')
        ActiveSupport::Notifications.instrument('fill_form.pdf') do
          pdf = PdfForms.new(ENV['PDFTK'], :flatten => @flatten)
          pdf.fill_form template, result_pdf, @json
        end
      ensure
        result_pdf.close
      end
      add_continuation_sheets(result_pdf.path)
      strike_out_applicable_statements result_pdf
    end

    result_pdf
  end

  private

  def further_claimants
    @claim.claimants.further_participants
  end

  def further_defendants
    @claim.defendants.further_participants
  end

  def add_checklist
    Checklist.new(@json).add
  end

  def add_document_count
    DocumentCount.new(@json).add
  end

  def reverse_possession_hearing!
    @json['possession_hearing'] = @json['possession_hearing'] == 'Yes' ? 'No' : 'Yes'
  end

  def remove_backslash_r!
    @json.each do |key, value|
      if value && value.include?("\r\n")
        @json[key] = value.gsub("\r\n","\n")
      end
    end

    @json.each do |key, value|
      if value && value.include?("\r")
        @json[key] = value.gsub("\r","")
      end
    end
  end

  CONTINUATION_SHEET_TEMPLATE = [ File.join(Rails.root, 'templates', 'continuation_sheet_0.pdf'), File.join(Rails.root, 'templates', 'continuation_sheet_1.pdf') ]
  STRIKER_JAR                 = File.join Rails.root, 'scripts', 'striker-0.3.1-standalone.jar'

  def defendant_two_data
    { 'defendant_2_address'   => "#{@json['defendant_2_address']}",
      'defendant_2_postcode1' => "#{@json['defendant_2_postcode1']}",
      'defendant_2_postcode2' => "#{@json['defendant_2_postcode2']}" }
  end

  # takes an array of two-element hashes. Each hash has keys 'left' and 'right' representing
  # the left and right hand columns of the continuation sheet
  #
  def add_continuation_sheets(result_path)
    (0 .. 1).each do | sheet_num |
      if @json.key?("continuation_sheet_#{sheet_num}_left")
        add_continuation_sheet(result_path, sheet_num, @json["continuation_sheet_#{sheet_num}_left"], @json["continuation_sheet_#{sheet_num}_right"])
      end
    end
  end

  def add_continuation_sheet(result_path, sheet_num, left, right)
    continuation_sheet_pdf = Tempfile.new('continuation_sheet_#{sheet_num}', '/tmp/')
    pdf = PdfForms.new(ENV['PDFTK'], :flatten => @flatten)
    pdf.fill_form CONTINUATION_SHEET_TEMPLATE[sheet_num], continuation_sheet_pdf, {"left_panel#{sheet_num}" => left, "right_panel#{sheet_num}" => right}
    combine_pdfs result_path, continuation_sheet_pdf.path
  end

  def combine_pdfs result_path, continuation_path
    combinded = Tempfile.new('combined', '/tmp/')
    %x[#{ENV['PDFTK']} #{result_path} #{continuation_path} cat output #{combinded.path}]
    FileUtils.mv combinded.path, result_path
  end

  def self.build_lines_hash(x0, x1, y)
    { x0: x0, x1: x1, y: y }
  end

  FIRST_3A_LINES = [
    build_lines_hash(42, 515, 327 + 57),
    build_lines_hash(42, 120, 315 + 56)
  ]
  FIRST_3B_LINES = [
    build_lines_hash(42, 505, 299 + 57)
  ]
  FIRST_3C_LINES = [
    build_lines_hash(42, 515, 282 + 57),
    build_lines_hash(42, 100, 270 + 55)
  ]
  SECOND_3A_LINES = [
    build_lines_hash(42, 420, 215 + 52)
  ]
  SECOND_3B_LINES = [
    build_lines_hash(42, 465, 198 + 51)
  ]
  SECOND_3C_3D_LINES = [
    build_lines_hash(42, 505, 180 + 49),
    build_lines_hash(42, 470, 160 + 50),
    build_lines_hash(42, 475, 123 + 48)
  ]

  def strike_out_paths index
    case index
    when 1
      FIRST_3A_LINES
    when 2
      FIRST_3B_LINES
    when 3
      FIRST_3C_LINES
    when 4
      SECOND_3A_LINES
    when 5
      SECOND_3B_LINES
    when 6
      SECOND_3C_3D_LINES
    end
  end

  def add_applicable_statement_strike_outs list
    1.upto(6) do |index|
      if statement_applicable(index)
        strike_out_paths(index).each do |line|
          list << { page: 3,
                    x: line[:x0],
                    y: line[:y],
                    x1: line[:x1],
                    y1: 0,
                    thickness: 1 }
        end
      end
    end
  end

  def statement_applicable(index)
    @json["tenancy_applicable_statements_#{index}"][/No/]
  end

  def add_previous_tenancy_type_strike_out list
    case @json['tenancy_previous_tenancy_type']
    when Tenancy::ASSURED
      list << build_hash_for_list(309, 557, 37)
      list << build_hash_for_list(488, 542, 43)
    when Tenancy::SECURE
      list << build_hash_for_list(430, 542, 55)
      list << build_hash_for_list(266, 557, 42)
    else
      # do nothing
    end
  end

  def build_hash_for_list(x, y, x1)
    { page: 3, x: x, y: y, x1: x1, y1: 0, thickness: 1 }
  end

  def strike_out_applicable_statements result_pdf
    list = []
    add_previous_tenancy_type_strike_out list
    add_applicable_statement_strike_outs(list) unless @json["tenancy_demoted_tenancy"] == 'Yes'
    ActiveSupport::Notifications.instrument('add_strikes_via_cli.pdf') do
      perform_strike_through(list, result_pdf) unless list.empty?
    end
  end

  def perform_strike_through list, result_pdf
    output_pdf = Tempfile.new('strike_out', '/tmp/')
    begin
      call_strike_through_service list, result_pdf, output_pdf
    rescue Faraday::ConnectionFailed, Errno::EPIPE, Exception => e
      LogStuff.warn(:strike_through_error) { "e: #{e.class}: #{e.to_s}:\n  #{e.backtrace[0..3].join("\n  ")}" }
      use_strike_through_command list, result_pdf, output_pdf, 'error_add_strikes_commandline.pdf'
    end

    unless File.exists?(output_pdf.path)
      use_strike_through_command list, result_pdf, output_pdf, 'missing_file_add_strikes_commandline.pdf'
    end

    FileUtils.mv output_pdf.path, result_pdf.path if non_test_or_browser?

    LogStuff.info(:strike_through, :debug) { "result_pdf: #{result_pdf.path} size: #{File.size?(result_pdf.path)}" }
  end

  def non_test_or_browser?
    !Rails.env.test? || ENV['browser']
  end

  def call_strike_through_service list, result_pdf, output_pdf
    connection = Faraday.new(url: 'http://localhost:4000')
    response = connection.post do |request|
      ActiveSupport::Notifications.instrument('add_strikes_via_service.pdf') do
        request.path = '/'
        request.body = strike_through_json(list, result_pdf, output_pdf)
        request.headers['Content-Type'] = 'application/json'
        request.headers['Accept'] = 'application/json'
      end
    end
  end

  def use_strike_through_command list, result_pdf, output_pdf, instrumentation_label
    ActiveSupport::Notifications.instrument(instrumentation_label) do
      call_strike_through_command list, result_pdf, output_pdf
    end
  end

  def call_strike_through_command list, result_pdf, output_pdf
    if non_test_or_browser?
      strikes = nil
      ActiveSupport::Notifications.instrument('store_strikes.pdf') do
        strikes = Tempfile.new('strikes.json', '/tmp/')
        strikes.write({ 'strikes' => list, 'flatten' => "#{@flatten}" }.to_json)
        strikes.close
      end
      path = `pwd`
      cmd = "cd /tmp; java -jar #{STRIKER_JAR} -i #{result_pdf.path.sub('/tmp/','')} -o #{output_pdf.path.sub('/tmp/','')} -j #{strikes.path}; cd #{path}"
      `#{cmd}`
    end
  end

  def strike_through_json list, result_pdf, output_pdf
    {
      'strikes' => list,
      'input' => result_pdf.path,
      'output' => output_pdf.path,
      'flatten' => @flatten
    }.to_json
  end
end

