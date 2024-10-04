# frozen_string_literal: true

require "json"
require "rest-client"
require "canvas_lms_api/response"

module CanvasLmsApi
  class Request
    def initialize(uri, method = nil, payload = nil)
      @uri = uri
      @method = method
      @payload = payload
    end

    def call
      CanvasLmsApi::Response.new(rest_request.execute, self)
    rescue RestClient::BadRequest => e
      message = JSON.parse(e.response)["message"]
      raise CanvasLmsApi::BadRequest.new(e.message + ": #{message}")
    end

    private

    def rest_request
      @rest_request ||= RestClient::Request.new(
        url: @uri.to_s,
        method: @method || :get,
        payload: @payload,
        headers: headers
        # verify_ssl: false
      )
    end

    def headers
      {"Authorization" => "Bearer #{@api_key}"}
    end
  end
end
