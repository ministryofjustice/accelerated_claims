class PostcodeLookupProxyController < ApplicationController

  def show
    Rails.logger.info ">>>>>>>>>>>> ClaimController.live_postcode_lookup?  #{ClaimController.live_postcode_lookup?}"
    @pclp = PostcodeLookupProxy.new(params[:pc], ClaimController.live_postcode_lookup?)
    
    respond_to do |format|
      if @pclp.invalid?
        format.json { render json: "Invalid postcode", status: :unprocessable_entity }
      elsif @pclp.lookup == true
        if @pclp.empty?
          format.json { render json: "No matching postcodes", status: :not_found }
        else
          format.json { render json: @pclp.result_set, status: :ok }
        end
      else
        format.json { render json: "Service not available", status: :service_unavailable}
      end
    end

  end

end