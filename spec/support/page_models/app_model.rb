class AppModel
  include Capybara::DSL
  include RSpec::Matchers

  attr_reader :homepage, :claim_form, :confirmation_page, :pdf

  def initialize(data)
    @homepage = HomePage.new
    @claim_form = ClaimForm.new(data)
    @confirmation_page = ConfirmationPage.new(data)
    @pdf = PdfModel.new
  end

  def exec(&block)
    instance_eval(&block)
  end
end