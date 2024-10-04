# frozen_string_literal: true

require "rack/utils"
require "active_support/core_ext/hash"

module CanvasLmsApi
  class Uri
    PER_PAGE = 999

    attr_reader :prefix, :endpoint, :query_param

    def initialize(prefix, endpoint, query_param)
      @prefix = fix_prefix(prefix)
      @endpoint = fix_endpoint(endpoint, @prefix)
      @query_param = query_param
    end

    def uri
      URI("#{prefix}#{endpoint}").tap do |u|
        query = Rack::Utils.parse_nested_query u.query
        query.merge! Hash(query_param)
        query[:per_page] ||= PER_PAGE
        u.query = query.to_query
      end
    end

    def to_s
      uri.to_s
    end

    private

    def fix_prefix(prefix)
      "#{prefix}/api/v1/"
    end

    def fix_endpoint(endpoint, prefix)
      endpoint.delete_prefix(prefix)
    end
  end
end
