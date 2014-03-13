class StaticController < ApplicationController
  def cookies
    @page_title = 'Cookies'
    render 'cookies'
  end
end
