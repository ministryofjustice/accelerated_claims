class AppModel
  include Capybara::DSL

  attr_reader :home, :claim_form, :confirmation_page, :pdf

  def initialize(data)
 #   @home = HomePage.new(data)
    @claim_form = ClaimForm.new(data)
    @confirmation_page = ConfirmationPage.new(data)
    @pdf = PdfModel.new
  end
end