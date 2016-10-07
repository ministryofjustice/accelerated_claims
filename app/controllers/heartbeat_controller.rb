class HeartbeatController < ApplicationController
  def ping
    render json: {
        version_number: ENV['VERSION_NUMBER'] || 'Not Available',
        build_date: ENV['BUILD_DATE'] || 'Not Available',
        commit_id: ENV['COMMIT_ID'] || 'Not Available',
        build_tag: ENV['BUILD_TAG'] || 'Not Available'
    }.to_json
  end

  def healthcheck
    render json: {
      checks: {
        server: true,
        strike: strike_status
      }
    }, status: strike_status ? 200 : 500
  end

  def strike_status
    connection = Faraday.new(url: 'http://localhost:4000')
    connection.get.status == 200
  end
end
