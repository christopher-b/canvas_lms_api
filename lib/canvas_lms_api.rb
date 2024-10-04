# frozen_string_literal: true

require_relative "canvas_lms_api/version"
require_relative "canvas_lms_api/client"
# require "canvas_lms_api/request_methods"
# require "canvas_lms_api/request"
# require "canvas_lms_api/response"
# require "canvas_lms_api/results"
# require "canvas_lms_api/uri"

require "canvas_lms_api/client"

module CanvasLmsApi
  class BadRequest < StandardError
    attr_accessor :request
  end

  class << self
    attr_writer :logger
    def logger
      @logger ||= logger.new("/dev/null").tap do |log|
        log.progname = name
      end
    end
  end
end
