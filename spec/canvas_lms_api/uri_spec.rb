require "spec_helper"
require "canvas_lms_api/uri"

RSpec.describe CanvasLmsApi::Uri do
  let(:prefix) { "https://canvas.example.com" }
  let(:endpoint) { "courses" }
  let(:query_param) { {page: 1, order_by: "name"} }
  let(:uri_instance) { described_class.new(prefix, endpoint, query_param) }

  describe "#initialize" do
    it "correctly sets the prefix" do
      expect(uri_instance.prefix).to eq("#{prefix}/api/v1/")
    end

    it "sets the endpoint when no modifications are needed" do
      expect(uri_instance.endpoint).to eq(endpoint)
    end

    it "removes the prefix from the endpoint" do
      endpoint_with_prefix = "#{prefix}/api/v1/courses"
      uri_instance_with_prefix = described_class.new(prefix, endpoint_with_prefix, query_param)
      expect(uri_instance_with_prefix.endpoint).to eq("courses")
    end
  end

  describe "#uri" do
    it "constructs a URI object with the correct format" do
      expected_uri = URI("#{prefix}/api/v1/courses?order_by=name&page=1&per_page=999")
      expect(uri_instance.uri).to eq(expected_uri)
    end

    it "merges query parameters and adds per_page if not provided" do
      no_per_page_query = {page: 1, order_by: "name"}
      uri_instance_no_per_page = described_class.new(prefix, endpoint, no_per_page_query)

      expected_uri = URI("#{prefix}/api/v1/courses?order_by=name&page=1&per_page=999")
      expect(uri_instance_no_per_page.uri).to eq(expected_uri)
    end

    it "does not override per_page if already present in the query parameters" do
      custom_per_page_query = { page: 1, order_by: "name", per_page: 500 }
      uri_instance_custom_per_page = described_class.new(prefix, endpoint, custom_per_page_query)

      expected_uri = URI("#{prefix}/api/v1/courses?order_by=name&page=1&per_page=500")
      expect(uri_instance_custom_per_page.uri).to eq(expected_uri)
    end
  end

  describe "#to_s" do
    it "returns the URI as a string" do
      expected_uri_string = "#{prefix}/api/v1/courses?order_by=name&page=1&per_page=999"
      expect(uri_instance.to_s).to eq(expected_uri_string)
    end
  end
end

