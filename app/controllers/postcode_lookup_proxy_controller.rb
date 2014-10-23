class PostcodeLookupProxyController < ApplicationController

  def show
    @pclp = PostcodeLookupProxy.new(params[:pc], live_postcode_lookup?)
    
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


  private

  def live_postcode_lookup?
    session[:postcode_lookup_mode] == 'live'
  end

end