class PostcodeLookupProxyController < ApplicationController

  def show
    @pclp = PostcodeLookupProxy.new(params[:pc], CountryNameNormalizer.new(params).normalize, live_postcode_lookup?)
    @pclp.lookup

    respond_to do |format|
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
    use_live_postcode_lookup = (URI(request.referer).query =~ /livepc=1/).nil? ? false : true
    use_live_postcode_lookup || production
  end

end