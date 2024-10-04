require "spec_helper"

RSpec.describe CanvasLmsApi::Client do
  let(:api_prefix) { "https://canvas.example.com" }
  let(:api_key) { "test_api_key" }
  let(:client) { described_class.new(api_prefix, api_key) }

  before do
    # Enable WebMock for HTTP request mocking
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  describe "#initialize" do
    it "initializes the client with prefix and API key" do
      expect(client.instance_variable_get(:@prefix)).to eq(api_prefix)
      expect(client.instance_variable_get(:@api_key)).to eq(api_key)
    end
  end

  describe "#get" do
    it "makes a GET request to the correct endpoint" do
      stub_request(:get, "#{api_prefix}/api/v1/courses?per_page=999")
        .to_return(
          status: 200,
          body: '[{"id": 1, "name": "Course"}]'
        )

      response = client.get("courses")
      expect(response).to eq({"id" => 1, "name" => "Course"})
    end
  end

  describe "#post" do
    it "makes a POST request to the correct endpoint with the correct payload" do
      payload = '{"name":"New Course"}'
      stub_request(:post, "#{api_prefix}/api/v1/courses?per_page=999")
        .with(body: payload)
        .to_return(
          status: 201,
          body: '{"id": 1, "name": "New Course"}'
        )

      response = client.post("courses", payload)
      expect(response).to eq({"id" => 1, "name" => "New Course"})
    end
  end

  describe "#put" do
    it "makes a PUT request to update the resource" do
      payload = '{"name": "Updated Course"}'
      stub_request(:put, "#{api_prefix}/api/v1/courses/1?per_page=999")
        .with(body: payload)
        .to_return(
          status: 200,
          body: '{"id": 1, "name": "Updated Course"}'
        )

      response = client.put("courses/1", payload)
      expect(response).to eq({"id" => 1, "name" => "Updated Course"})
    end
  end

  # describe "#delete" do
  #   it "makes a DELETE request to the correct endpoint" do
  #     stub_request(:delete, "#{api_prefix}/api/v1/courses/1?per_page=999")
  #       .to_return(
  #         status: 204,
  #         body: "{}"
  #         # body: '{"deleted":"true"}',
  #       )
  #
  #     response = client.delete("courses/1")
  #     expect(response).to be_nil
  #   end
  # end

  describe "#request" do
    context "when handling pagination" do
      it "follows pagination links" do
        stub_request(:get, "#{api_prefix}/api/v1/courses?per_page=999")
          .to_return(
            status: 200,
            body: '[{"id": 1, "name": "Course 1"}]',
            headers: {"link" => '<https://canvas.example.com/api/v1/courses?page=2>; rel="next"'}
          )
        stub_request(:get, "#{api_prefix}/api/v1/courses?page=2&per_page=999")
          .to_return(
            status: 200,
            body: '[{"id": 2, "name": "Course 2"}]'
          )

        response = client.get("courses")
        expect(response).to eq([
          {"id" => 1, "name" => "Course 1"},
          {"id" => 2, "name" => "Course 2"}
        ])
      end
    end

    context "when handling errors" do
      it "raises a BadRequest error when a bad request occurs" do
        stub_request(:get, "#{api_prefix}/api/v1/courses?per_page=999")
          .to_return(
            status: 400,
            body: '{"message": "Bad Request"}'
          )

        expect {
          client.get("courses")
        }.to raise_error(CanvasLmsApi::BadRequest)
      end
    end
  end

  # describe "#next_page" do
  #   it "extracts the next page URL from the link header" do
  #     headers = { "link" => '<https://canvas.example.com/api/v1/courses?page=2>; rel="next"' }
  #     response = double("response", headers: headers)
  #
  #     next_page = client.send(:next_page, response)
  #     expect(next_page).to eq("courses?page=2")
  #   end
  #
  #   it "returns nil if there is no next page" do
  #     headers = {"link" => ""}
  #     response = double("response", headers: headers)
  #
  #     next_page = client.send(:next_page, response)
  #     expect(next_page).to be_nil
  #   end
  # end
end
