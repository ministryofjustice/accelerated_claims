class PostcodeLookupProxyController < ApplicationController

  def show
    @pclp = PostcodeLookupProxy.new(params[:pc], CountryNameNormalizer.new(params).normalize, live_postcode_lookup?)
    @pclp.lookup

    respond_to do |format|
      puts "++++++ DEBUG RETURNING #{@pclp.result_set.inspect}  ++++++ #{__FILE__}::#{__LINE__} ++++\n"
      format.json { render json: @pclp.result_set, status: @pclp.http_status }
    end
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