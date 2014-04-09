class PDFDocument
  def initialize(json)
    @json = json
  end

  def fill
    begin
      template = File.join Rails.root, "templates", "form.pdf"
      result_pdf = Tempfile.new('accelerated_claim', '/tmp/')
      pdf = PdfForms.new(ENV["PDFTK"])
      pdf.fill_form template, result_pdf, @json

      add_defendant_two result_pdf

      result_pdf.path
    ensure
      result_pdf.close
    end
  end

  private

  def add_defendant_two result_pdf
    if @json.key? "defendant_two_address"
      continuation_template = File.join Rails.root, "templates", "defendant_form.pdf"
      defendant_two = "#{@json["defendant_two_address"]}\n#{@json["defendant_two_postcode1"]} #{@json["defendant_two_postcode2"]}"
      continuation_pdf = Tempfile.new('continuation', '/tmp/')
      combined_pdf = Tempfile.new('combined', '/tmp/')
      pdf = PdfForms.new(ENV["PDFTK"])
      pdf.fill_form continuation_template, continuation_pdf, { "defendant_two" => "#{defendant_two}" }
      %x[#{ENV["PDFTK"]} #{result_pdf.path} #{continuation_pdf.path} cat output #{combined_pdf.path}]
      FileUtils.mv "#{combined_pdf.path}", "#{result_pdf.path}"
    end
  end

  def strike_out_paths index
    case index
    when 1
      [
        { x0: 35, x1: 505, y: 327 },
        { x0: 35, x1: 150, y: 315 }
      ]
    when 2
      [ { x0: 35, x1: 505, y: 299 } ]
    when 3
      [
        { x0: 35, x1: 515, y: 282 },
        { x0: 35, x1: 150, y: 270 }
      ]
    when 4
      [ { x0: 35, x1: 450, y: 215 } ]
    when 5
      [ { x0: 35, x1: 475, y: 198 } ]
    when 6
      [
        { x0: 35, x1: 505, y: 180 },
        { x0: 35, x1: 505, y: 160 }
      ]
    when 7
      [ { x0: 35, x1: 505, y: 123 } ]
    end
  end

  def strike_out_applicable_statements
    1.upto(6) do |index|
      if @json['tenancy'].delete("applicable_statements_#{index}")[/No/]
        strike_out_paths(index).each do |path|
          strike_out path
        end
      end
    end
  end

  def strike_out path
  end
end
