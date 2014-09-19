class PostcodeLookupProxyController < ApplicationController

  def show
    @pclp = PostcodeLookupProxy.new(params[:pc])


    
    respond_to do |format|
      if @pclp.invalid?
        format.json { render json: "Invalid postcode" }
      elsif @pclp.lookup == true
        if @pclp.empty?
          format.json { render json: "No matching postcodes" }
        else
          format.json { render json: @pclp.result_set }
        end
      else
        format.json { render json: "Service not available", status: :service_unavailable}
      end
    end

  end

end