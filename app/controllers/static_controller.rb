class StaticController < ApplicationController
  def cookies
    @page_title = 'Cookies'
    render 'cookies'
  end
  def terms
    @page_title = 'Terms and conditions and privacy policy'
    render 'terms'
  end
end
