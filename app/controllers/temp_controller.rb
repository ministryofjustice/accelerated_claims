class TempController < ApplicationController

  def pdf
    @page_title = 'Property repossession'
    render 'pdf'
  end
  def form
    @page_title = 'Property repossession'
    render 'form'
  end

end
