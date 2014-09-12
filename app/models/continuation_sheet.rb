
# Class to format the output on the continuation sheet for additional claimants and defendants
# API fo usage
#
#
#     cs = ContinuationSheet.new( [array_of_additional_claimants], [array_of_additional_defendants])
#     cs.generate
#     cs.as_json     
#
#     produces a hash like this:
#
#
#     {"continuation" => {
#         "sheet_0_left"  => "data to go in left panel of sheet 0",
#         "sheet_0_right" => "data to go in right panel of sheet 0",
#         "sheet_1_left"  => "data to go in left panel of sheet 1",
#         "sheet_1_right" => "data to go in right panel of sheet 1",
#       }
#     }
#



class ContinuationSheet

  @@indentation       = 4
  @@newline_threshold = 55



  # instantiate a ContinuatinoSheet object with the ADDITIONAL claimants and defendants
  def initialize(claimants, defendants)
    @claimants           = claimants
    @defendants          = defendants
    @panels              = [ ]
    @num_panels          = 0
    @current_panel_index = nil
    @pages               = [ ]
  end


  def generate
    if any_claimants?
      add_participant_header(:claimant)
      @claimants.each { |claimant| add_to_panels(claimant) }
    end

    if any_defendants?
      add_participant_header(:defendant)
      @defendants.each { |defendant| add_to_panels(defendant) }
    end
    format_pages
  end
  

  def empty?
    @claimants.empty? && @defendants.empty?
  end


  def any_defendants?
    @defendants.any?
  end


  def any_claimants?
    @claimants.any?
  end

  def as_json
    json = { }
    @pages.each_with_index do |page, index|
      json["sheet_#{index}_left"] = page['left']
      json["sheet_#{index}_right"] = page['right']
    end
    { 'continuation' => json }
  end
  



  private

  def claimants_header
    "Additional Claimants\n====================\n\n\n"
  end


  def defendants_header
    "Additional Defendants\n=====================\n\n\n"
  end


  def current_panel
    @panels[@current_panel_index]
  end

  def current_panel=(string)
    @panels[@current_panel_index] = string
  end


  def add_participant_header(participant_type)
    add_panel if needs_new_panel?
    header = case participant_type
    when :claimant
      claimants_header
    when :defendant
      defendants_header
    end
    append_to_current_panel(header)
  end

  
  def needs_new_panel?
    @current_panel_index.nil? || num_newlines > @@newline_threshold
  end


  def num_newlines
    return 0 if @current_panel_index.nil?
    current_panel.count("\n")
  end


  def add_panel
    @panels << ""
    @current_panel_index = @current_panel_index.nil? ? 0 : @current_panel_index + 1
    @num_panels += 1
  end

  def append_to_current_panel(appendage)
    @panels[@current_panel_index] += appendage
  end



  def add_to_panels(object)
    add_panel if needs_new_panel?
    append_to_current_panel(object.numbered_header)
    append_to_current_panel(object.indented_details(@@indentation))
    append_to_current_panel("\n\n")
    remove_backslash_r
  end


  def remove_backslash_r
    @panels[@current_panel_index].gsub!("\r\n", "\n")
  end

  def format_pages
    pending = true
    page = {}
    @panels.each_with_index do |panel, index|
      if index % 2 == 0
        page['left'] = panel
        if index == @num_panels - 1
          page['right'] = ''
          @pages << page 
        end
      else
        page['right'] =  panel
        @pages << page
        page = {}
      end
    end
  end

 
end



