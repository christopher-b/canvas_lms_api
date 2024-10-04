# frozen_string_literal: true

require "rest-client"

# This is a wrapper around a result set, which allows us to collect
# results across paginated responses

module CanvasLmsApi
  class Results
    attr_accessor :value

    def initialize
      @value = nil
    end

    def collect(new_results)
      if value.nil?
        self.value = new_results
      elsif new_results.is_a? Hash
        new_results.each_pair do |k, v|
          if value.key?(k) && value[k].is_a?(Array)
            value[k].concat(v)
          else
            value[k] = v
          end
        end
      else
        value.try(:concat, new_results)
      end
    end

    # This was a bad decision and I should work to remove it
    def coalesce_results
      if value.is_a? Array
        value.one? ? value.first : value
      else
        value
      end
    end
  end
end
