# frozen_string_literal: true

require "canvas_lms_api/request_methods"
require "canvas_lms_api/request"
require "canvas_lms_api/results"
require "canvas_lms_api/uri"

# @TODO extract URI
# extract CRUD methods
# extract pagination?

module CanvasLmsApi
  class Client
    include CanvasLmsApi::RequestMethods

    def initialize(prefix, api_key)
      @prefix = prefix
      @api_key = api_key
    end

    def request(endpoint, params = {})
      uri = uri_for(endpoint, params[:query])
      loop do
        response = CanvasLmsApi::Request.new(
          uri,
          @api_key,
          params[:method],
          params[:payload]
        ).call
        results.collect(response.body)
        next_page_uri = response.next_page

        break unless next_page_uri
        uri = uri_for(next_page_uri)
      end

      results.coalesce_results
    end

    private

    def results
      @results ||= CanvasLmsApi::Results.new
    end

    def uri_for(endpoint, params = nil)
      CanvasLmsApi::Uri.new(@prefix, endpoint, params)
    end
  end
end
