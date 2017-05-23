class HealthCheckController < ApplicationController
  def ping
    render json: {
      version_number: ENV['APPVERSION'] || 'unknown',
      build_date: ENV['APP_BUILD_DATE'] || 'unknown',
      commit_id: ENV['APP_GIT_COMMIT'] || 'unknown',
      build_tag: ENV['APP_BUILD_TAG'] || 'unknown'
    }
  end

  def healthcheck
    render json: {
      web_server: 'ok',
      strike_server: ''}
  end
end
