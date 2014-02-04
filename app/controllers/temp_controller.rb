class TempController < ApplicationController

  def pdf
    @page_title = 'Property repossession'
    render 'pdf'
  end

end
