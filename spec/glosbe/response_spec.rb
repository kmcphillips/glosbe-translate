# frozen_string_literal: true
require "spec_helper"

RSpec.describe Glosbe::Response do
  def response_for_cassette(cassette)
    VCR.use_cassette(cassette) do
      JSON.parse(VCR.current_cassette.http_interactions.interactions.first.response.body)
    end
  end

  let(:response_success) do
    Glosbe::Response.new(response_for_cassette("translate_eng_fr_hello"), ok: true)
  end

  let(:response_no_results) do
    Glosbe::Response.new(response_for_cassette("translate_eng_fr_xxxxx"), ok: true)
  end

  let(:response_bad_request) do
    Glosbe::Response.new("<html>Oh no!</html>", ok: false)
  end

  describe "#initialize" do
    let(:body) { { key: "value" } }
    let(:response) { Glosbe::Response.new(body, ok: "yes") }

    it "passes in the body and the ok: param" do
      expect(response.body).to eq(body)
      expect(response.ok).to eq(true)
    end
  end

  describe "#from" do
    it "on success parses the from out of the response" do
      expect(response_success.from).to eq("en")
    end

    it "on no results parses the from out of the response" do
      expect(response_no_results.from).to eq("en")
    end

    it "on bad request does not have anything to parse" do
      expect(response_bad_request.from).to be_nil
    end
  end

  describe "#to" do
    it "on success parses the to out of the response" do
      expect(response_success.to).to eq("fr")
    end

    it "on no results parses the to out of the response" do
      expect(response_no_results.to).to eq("fr")
    end

    it "on bad request does not have anything to parse" do
      expect(response_bad_request.to).to be_nil
    end
  end

  describe "#success?" do
    it "is false when ok: is false" do
      expect(Glosbe::Response.new({"result" => "ok"}, ok: false)).to_not be_success
    end

    it "is false when 'result' is not 'ok'" do
      expect(Glosbe::Response.new({"result" => "ohyes"}, ok: true)).to_not be_success
    end

    it "is true when both ok: is true and 'result' is ok" do
      expect(Glosbe::Response.new({"result" => "ok"}, ok: true)).to be_success
    end

    context "with real request data" do
      it "on success is true" do
        expect(response_success).to be_success
      end

      it "on no results is true" do
        expect(response_no_results).to be_success
      end

      it "on bad request is false" do
        expect(response_bad_request).to_not be_success
      end
    end
  end

  describe "#found?" do
    it "on success is true" do
      expect(response_success).to be_found
    end

    it "on no results is false" do
      expect(response_no_results).to_not be_found
    end

    it "on bad request is false" do
      expect(response_bad_request).to_not be_found
    end
  end

  describe "#results" do
    context "on success" do
      it "has results" do
        expect(response_success.results).to_not be_empty
      end

      it "has an array of results"
    end

    it "on no results is an empty array" do
      expect(response_no_results.results).to eq([])
    end

    it "on bad request is an empty array" do
      expect(response_bad_request.results).to eq([])
    end
  end
end
