# frozen_string_literal: true

module CanvasLmsApi
  module RequestMethods
    def get(endpoint, query = nil)
      request(endpoint, method: :get, query: query)
    end

    def post(endpoint, payload = nil)
      request(endpoint, method: :post, payload: payload)
    end

    def put(endpoint, payload = nil, params = {})
      request(endpoint, method: :put, payload: payload)
    end

    # def delete(endpoint, payload = nil)
    #   request(endpoint, method: :delete, payload: payload)
    # end
  end
end
