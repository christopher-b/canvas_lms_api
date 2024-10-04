require "spec_helper"
require "json"
require "rest-client"

RSpec.describe CanvasLmsApi::Response do
  let(:rest_response) { instance_double(RestClient::Response, body: response_body, headers: response_headers) }
  let(:request) { instance_double(RestClient::Request) }
  let(:response) { described_class.new(rest_response, request) }
  let(:response_body) { {"data" => ["item1", "item2"]}.to_json }
  let(:response_headers) { {} }

  describe "#body" do
    it "parses the response body as JSON" do
      expect(response.body).to eq({"data" => ["item1", "item2"]})
    end

    it "memoizes the parsed body" do
      expect(JSON).to receive(:parse).once.and_return({"data" => ["item1", "item2"]})
      2.times { response.body }
    end
  end

  describe "#next_page" do
    context "when the response has a link header for the next page" do
      let(:response_headers) do
        {
          link: '<https://canvas.example.com/api/v1/courses?page=2>; rel="next"'
        }
      end

      it "returns the URL for the next page" do
        expect(response.next_page).to eq("courses?page=2")
      end
    end

    context "when the response does not have a link header" do
      let(:response_headers) { {} }

      it "returns nil" do
        expect(response.next_page).to be_nil
      end
    end

    context "when the response has no 'next' relation in the link header" do
      let(:response_headers) do
        {
          link: '<https://canvas.example.com/api/v1/courses?page=1>; rel="prev"'
        }
      end

      it "returns nil" do
        expect(response.next_page).to be_nil
      end
    end

    context "when the response headers contain multiple links" do
      let(:response_headers) do
        {
          link: '<https://canvas.example.com/api/v1/courses?page=2>; rel="next", <https://canvas.example.com/api/v1/courses?page=1>; rel="prev"'
        }
      end

      it "returns the next page link" do
        expect(response.next_page).to eq("courses?page=2")
      end
    end
  end
end

