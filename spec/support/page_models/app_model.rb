class AppModel
  include Capybara::DSL
  include RSpec::Matchers

  attr_reader :claim_form, :confirmation_page, :pdf

  def initialize(data)
    @claim_form = ClaimForm.new(data)
    @confirmation_page = ConfirmationPage.new
    @pdf = PdfModel.new
  end

  def exec(&block)
    instance_eval(&block)
  end
end