require "spec_helper"

RSpec.describe CanvasLmsApi::Results do
  let(:results) { described_class.new }

  describe "#collect" do
    context "when the value is initially nil" do
      let(:new_results) { ["item1", "item2"] }

      it "sets the value to the new results" do
        results.collect(new_results)
        expect(results.value).to eq(new_results)
      end
    end

    context "when the value is an array" do
      before { results.value = ["item1"] }
      let(:new_results) { ["item2", "item3"] }

      it "concatenates new results to the existing array" do
        results.collect(new_results)
        expect(results.value).to eq(["item1", "item2", "item3"])
      end
    end

    context "when the value is a hash" do
      before { results.value = {"key1" => ["item1"]} }
      let(:new_results) { {"key1" => ["item2", "item3"]} }

      it "merges new results into the existing hash and concatenates arrays" do
        results.collect(new_results)
        expect(results.value).to eq({"key1" => ["item1", "item2", "item3"]})
      end
    end

    context "when new results have different keys" do
      before { results.value = {"key1" => ["item1"]} }
      let(:new_results) { {"key2" => ["item2"]} }

      it "adds new keys and values into the existing hash" do
        results.collect(new_results)
        expect(results.value).to eq({"key1" => ["item1"], "key2" => ["item2"]})
      end
    end
  end

  describe "#coalesce_results" do
    context "when value is an array" do
      context "when the array has more than one element" do
        before { results.value = ["item1", "item2"] }

        it "returns the entire array" do
          expect(results.coalesce_results).to eq(["item1", "item2"])
        end
      end

      context "when the array has exactly one element" do
        before { results.value = ["item1"] }

        it "returns the first element of the array" do
          expect(results.coalesce_results).to eq("item1")
        end
      end
    end

    context "when value is not an array" do
      before { results.value = {"key" => "value"} }

      it "returns the value unchanged" do
        expect(results.coalesce_results).to eq({ "key" => "value" })
      end
    end

    context "when value is nil" do
      it "returns nil" do
        expect(results.coalesce_results).to be_nil
      end
    end
  end
end
