class PostcodeLookupProxyController < ApplicationController

  def show
    respond_to do |format|
      format.json do
        @pc_facade = PostcodeLookup::Facade.new(params[:vc], live_postcode_lookup?)
        @postcode = @pc_facade.lookup(params[:pc])
        
        render json: @pc_facade.status.to_h, status: @pc_facade.status.http_status
      end
    end
  end

  private

  def live_postcode_lookup?
    production = ['staging', 'production'].include?( ENV['ENV_NAME'] )
    came_from_livepc_page?(request.referer) || production
  end

  def came_from_livepc_page?(referer)
    referer && URI(request.referer).query =~ /livepc=1/
  end
  
end
