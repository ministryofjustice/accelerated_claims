class PostcodeLookupProxyController < ApplicationController

  def show
    @postcode = PostcodeLookupProxy.new(params[:pc])

    if @postcode.valid?

      respond_to do |format|
        format.json  { render json: @postcode.lookup }
      end
    else
      respond_to do |format|
        format.json { render json: "Invalid postcode" }
      end
    end
  end




end