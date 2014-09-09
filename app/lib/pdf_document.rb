class PDFDocument

  attr_reader :json

  def initialize(claim, flatten=true)

    @claim = claim
    @json = @claim.as_json

    
    @flatten = flatten
    remove_backslash_r!

    puts "++++++ DEBUG PDFDccumnet parameters ++++++ #{__FILE__}::#{__LINE__} ++++\n"
    pp @json


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

      cs = ContinuationSheet.new(further_claimants, further_defendants)
      cs.generate
      add_continuation_sheets(result_pdf.path, cs.pages)
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

  CONTINUATION_SHEET_TEMPLATE = File.join Rails.root, 'templates', 'continuation_sheet.pdf'
  STRIKER_JAR                = File.join Rails.root, 'scripts', 'striker-0.3.1-standalone.jar'

  def defendant_two_data
    { 'defendant_2_address'   => "#{@json['defendant_2_address']}",
      'defendant_2_postcode1' => "#{@json['defendant_2_postcode1']}",
      'defendant_2_postcode2' => "#{@json['defendant_2_postcode2']}" }
  end

  # takes an array of two-element hashes. Each hash has keys 'left' and 'right' representing 
  # the left and right hand columns of the continuation sheet
  #
  def add_continuation_sheets(result_path, continuation_sheet_pages)
    continuation_sheet_pages.each_with_index do |page, index|
      continuation_sheet_pdf = Tempfile.new('continuation_sheet_#{index}', '/tmp/')
      pdf = PdfForms.new(ENV['PDFTK'], :flatten => @flatten)
      puts "++++++ DEBUG LEFT PANEL ++++++ #{__FILE__}::#{__LINE__} ++++\n"
      pp page['left']
      
      pdf.fill_form CONTINUATION_SHEET_TEMPLATE, continuation_sheet_pdf, {'left_panel' => page['left'], 'right_panel' => page['right']}
      combine_pdfs result_path, continuation_sheet_pdf.path
    end
  end



  # def create_continuation_pdf
  #   continuation_pdf = Tempfile.new('continuation', '/tmp/')
  #   pdf = PdfForms.new(ENV['PDFTK'])
  #   pdf.fill_form CONTINUATION_TEMPLATE, continuation_pdf, defendant_two_data
  #   continuation_pdf.path
  # end

  def combine_pdfs result_path, continuation_path
    combinded = Tempfile.new('combined', '/tmp/')
    %x[#{ENV['PDFTK']} #{result_path} #{continuation_path} cat output #{combinded.path}]
    FileUtils.mv combinded.path, result_path
  end

  # def add_defendant_two result_path
  #   if @json.key? 'defendant_2_address'
  #     continuation_path = create_continuation_pdf
  #     combine_pdfs result_path, continuation_path
  #   end
  # end



  # def add_further_claimants(result_path)
  #   if @json.key?('claimant_3_address') || @json.key?('claimant_4_address')
  #     further_claimants_path = create_further_claimants_pdf
  #     combine_pdfs result_path, further_claimants_path
  #   end
  # end


  # def create_further_claimants_pdf
  #   further_claimants_pdf = Tempfile.new('further_claimants', '/tmp/')
  #   pdf = PdfForms.new(ENV['PDFTK'])
  #   pdf.fill_form FURTHER_CLAIMANTS_TEMPLATE, further_claimants_pdf, further_claimants_data
  #   further_claimants_pdf.path
  # end


  # def further_claimants_data
  #   further_claimants_string = "Further Claimants:\n\n"

  #   if @json.key?('claimant_3_address')
  #     further_claimants_string += @json['claimant_3_address']
  #     further_claimants_string += "\n" + @json['claimant_3_postcode1'] + ' ' + @json['claimant_3_postcode2'] + "\n\n"
  #   end

  #   if @json.key?('claimant_4_address')
  #     further_claimants_string += @json['claimant_4_address']
  #     further_claimants_string += "\n" + @json['claimant_4_postcode1'] + ' ' + @json['claimant_4_postcode2'] + "\n\n"
  #   end

  #   { 'further_claimants' => further_claimants_string }
  # end




  FIRST_3A_LINES = [
    { x0: 42, x1: 515, y: 327+57 },
    { x0: 42, x1: 120, y: 315+56 }
  ]
  FIRST_3B_LINES = [
    { x0: 42, x1: 505, y: 299+57 }
  ]
  FIRST_3C_LINES = [
    { x0: 42, x1: 515, y: 282+57 },
    { x0: 42, x1: 100, y: 270+55 }
  ]
  SECOND_3A_LINES = [
    { x0: 42, x1: 420, y: 215+52 }
  ]
  SECOND_3B_LINES = [
    { x0: 42, x1: 465, y: 198+51 }
  ]
  SECOND_3C_3D_LINES = [
    { x0: 42, x1: 505, y: 180+49 },
    { x0: 42, x1: 470, y: 160+50 },
    { x0: 42, x1: 475, y: 123+48 }
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
      if @json["tenancy_applicable_statements_#{index}"][/No/]
        strike_out_paths(index).each do |line|
          x = line[:x0]
          y = line[:y]
          x1 = line[:x1]
          list << { page: 3, x: x, y: y, x1: x1, y1: 0, thickness: 1 }
        end
      end
    end
  end

  def add_previous_tenancy_type_strike_out list
    case @json['tenancy_previous_tenancy_type']
    when Tenancy::ASSURED
      list << { page: 3, x: 309, y: 557, x1: 37, y1: 0, thickness: 1 }
      list << { page: 3, x: 488, y: 542, x1: 43, y1: 0, thickness: 1 }
    when Tenancy::SECURE
      list << { page: 3, x: 430, y: 542, x1: 55, y1: 0, thickness: 1 }
      list << { page: 3, x: 266, y: 557, x1: 42, y1: 0, thickness: 1 }
    else
      # do nothing
    end
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
      Rails.logger.warn "e: #{e.class}: #{e.to_s}:\n  #{e.backtrace[0..3].join("\n  ")}"
      use_strike_through_command list, result_pdf, output_pdf, 'error_add_strikes_commandline.pdf'
    end

    unless File.exists?(output_pdf.path)
      use_strike_through_command list, result_pdf, output_pdf, 'missing_file_add_strikes_commandline.pdf'
    end

    if !Rails.env.test? || ENV['browser']
      FileUtils.mv output_pdf.path, result_pdf.path
    end
    Rails.logger.debug "result_pdf: #{result_pdf.path} size: #{File.size?(result_pdf.path)}"
  end

  def call_strike_through_service list, result_pdf, output_pdf
    Rails.logger.debug "result_pdf: #{result_pdf.path} size: #{File.size?(result_pdf.path)}"
    connection = Faraday.new(url: 'http://localhost:4000')
    response = connection.post do |request|
      ActiveSupport::Notifications.instrument('add_strikes_via_service.pdf') do
        request.path = '/'
        request.body = strike_through_json(list, result_pdf, output_pdf)
        request.headers['Content-Type'] = 'application/json'
        request.headers['Accept'] = 'application/json'
      end
    end
    Rails.logger.debug "response: #{response.body}"
    Rails.logger.debug "output_pdf: #{output_pdf.path} size: #{File.size?(output_pdf.path)}"
  end

  def use_strike_through_command list, result_pdf, output_pdf, instrumentation_label
    ActiveSupport::Notifications.instrument(instrumentation_label) do
      call_strike_through_command list, result_pdf, output_pdf
    end
  end

  def call_strike_through_command list, result_pdf, output_pdf
    if !Rails.env.test? || ENV['browser']
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
