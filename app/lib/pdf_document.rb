class PDFDocument
  def initialize(json)
    @json = json
  end

  def fill
    begin
      template = File.join Rails.root, 'templates', 'form.pdf'
      result_pdf = Tempfile.new('accelerated_claim', '/tmp/')
      pdf = PdfForms.new(ENV['PDFTK'])
      pdf.fill_form template, result_pdf, @json
    ensure
      result_pdf.close
    end

    result_path = result_pdf.path
    add_defendant_two result_path
    strike_out_applicable_statements result_path
    result_pdf
  end

  private

  CONTINUATION_TEMPLATE = File.join Rails.root, 'templates', 'defendant_form.pdf'
  STRIKER_JAR = File.join Rails.root, 'scripts', 'striker-0.2.0-standalone.jar'

  def defendant_two_address
    "#{@json['defendant_two_address']}\n#{@json['defendant_two_postcode1']} #{@json['defendant_two_postcode2']}"
  end

  def create_continuation_pdf
    continuation_pdf = Tempfile.new('continuation', '/tmp/')
    pdf = PdfForms.new(ENV['PDFTK'])
    pdf.fill_form CONTINUATION_TEMPLATE, continuation_pdf, { 'defendant_two' => defendant_two_address }
    continuation_pdf.path
  end

  def combine_pdfs result_path, continuation_path
    combinded = Tempfile.new('combined', '/tmp/')
    %x[#{ENV['PDFTK']} #{result_path} #{continuation_path} cat output #{combinded.path}]
    FileUtils.mv combinded.path, result_path
  end

  def add_defendant_two result_path
    if @json.key? 'defendant_two_address'
      continuation_path = create_continuation_pdf
      combine_pdfs result_path, continuation_path
    end
  end

  def strike_out_paths index
    case index
    when 1
      [
        { x0: 42, x1: 515, y: 327+57 },
        { x0: 42, x1: 120, y: 315+56 }
      ]
    when 2
      [ { x0: 42, x1: 505, y: 299+57 } ]
    when 3
      [
        { x0: 42, x1: 515, y: 282+57 },
        { x0: 42, x1: 100, y: 270+55 }
      ]
    when 4
      [ { x0: 42, x1: 420, y: 215+52 } ]
    when 5
      [ { x0: 42, x1: 465, y: 198+51 } ]
    when 6
      [
        { x0: 42, x1: 505, y: 180+49 },
        { x0: 42, x1: 470, y: 160+50 },
        { x0: 42, x1: 475, y: 123+48 }
      ]
    end
  end

  def strike_out_applicable_statements result_path
    puts result_path
    hash = {}
    hash['strikes'] = []

    1.upto(6) do |index|
      if @json["tenancy_applicable_statements_#{index}"][/No/]
        strike_out_paths(index).each do |line|
          x = line[:x0]
          y = line[:y]
          x1 = line[:x1]
          hash['strikes'] << { page: 2, x: x, y: y, x1: x1, y1: 0, thickness: 1 }
        end
      end
    end

    unless hash['strikes'].empty?
      strike_out_all result_path, hash
    end
  end

  def strike_out_all result_path, hash
    output = Tempfile.new('strike_out', '/tmp/')
    strikes = Tempfile.new('strikes.json', '/tmp/')
    File.open('strikes.json', 'w') {|f| f.write hash.to_json}
    strikes.write hash.to_json
    strikes.close
    path = `pwd`
    cmd = "cd /tmp; java -jar #{STRIKER_JAR} -i #{result_path.sub('/tmp/','')} -o #{output.path.sub('/tmp/','')} -j #{strikes.path}; cd #{path}"
    puts cmd

    if !Rails.env.test? || ENV['browser']
      start = Time.now
      puts `#{cmd}`
      FileUtils.mv output.path, result_path
      puts "duration: #{Time.now - start} secs"
    end
  end

end
