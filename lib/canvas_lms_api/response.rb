# frozen_string_literal: true

module CanvasLmsApi
  class Response
    LINK_PATTERN = %r{^<https?://.*/api/v1/([^>]+)[^"]+"([^"]+)}

    attr_reader :rest_response, :request

    def initialize(rest_response, request)
      @rest_response = rest_response
      @request = request
    end

    def body
      @body ||= JSON.parse(rest_response.body)
    end

    def next_page
      @next_page ||= begin
        return nil unless rest_response.headers[:link]

        rest_response.headers[:link].split(",").each do |link|
          link.match(LINK_PATTERN) do |match|
            url = match[1]
            rel = match[2]
            return url if rel == "next"
          end
        end

        # No "next" link found
        nil
      end
    end
  end
end
