class PostcodeLookupProxyController < ApplicationController

  def show
    @pclp = PostcodeLookupProxy.new(params[:pc], CountryNameNormalizer.new(params).normalize, live_postcode_lookup?)
    @pclp.lookup
    
    respond_to do |format|
      format.json { render json: @pclp.result_set, status: @pclp.http_status }
    end


    #   if @pclp.invalid?
    #     format.json { render json: "Invalid postcode", status: :unprocessable_entity }
    #   elsif @pclp.lookup == true
    #     if @pclp.empty?
    #       if @pclp.result_code == 9404
    #         format.json { render json: "Postcode is in #{@pclp.result_message}.  You can only use this form if the property is in England and Wales", status: :bad_request }
    #       else
    #         format.json { render json: "No matching postcodes", status: :not_found }
    #       end
    #     else
    #       format.json { render json: @pclp.result_set, status: :ok }
    #     end
    #   else
    #     format.json { render json: "Service not available", status: :service_unavailable}
    #   end
    # end

  end


  private


  def country_params
    if params[:vc].present?
      transform_countries
    else
      []
    end
  end

 
  def live_postcode_lookup?
    production = ['staging', 'production'].include?( ENV['ENV_NAME'] )
    livepc = (URI(request.referer).query =~ /livepc=1/).nil? ? false : true
    livepc || production
  end

end