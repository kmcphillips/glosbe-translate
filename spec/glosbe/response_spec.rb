# frozen_string_literal: true
require "spec_helper"

RSpec.describe Glosbe::Response do
  shared_context "success" do
    use_vcr_cassette "translate_eng_fr_hello"

    let(:language) { Glosbe::Language.new(from: :eng, to: :fr) }
    let(:response) { language.response("hello") }
  end

  shared_context "no results" do
    use_vcr_cassette "translate_eng_fr_xxxxx"

    let(:language) { Glosbe::Language.new(from: :eng, to: :fr) }
    let(:response) { language.response("xxxxx") }
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
    include_context "success"

    it "parses the from out of the response" do
      expect(response.from).to eq("en")
    end
  end

  describe "#to" do
    context "success" do
      include_context "success"

      it "parses the to out of the response" do
        expect(response.to).to eq("fr")
      end
    end

    context "no results" do
      include_context "no results"

      it "parses the to out of the response" do
        expect(response.to).to eq("fr")
      end
    end
  end

  describe "#success?" do
    context "success" do
      include_context "success"

      it "looks at the result field" do
        expect(response.success?).to eq(true)
      end
    end

    context "no results" do
      include_context "no results"

      it "looks at the result field" do
        expect(response.success?).to eq(true)
      end
    end
  end

  describe "#found?" do
    context "success" do
      include_context "success"

      it "looks at the success and number of results" do
        expect(response.found?).to eq(true)
      end
    end

    context "no results" do
      include_context "no results"

      it "looks at the success and number of results" do
        expect(response.found?).to eq(false)
      end
    end
  end

  describe "#results" do
    context "success" do
      include_context "success"

      it "parses out the results" do
        expect(response.results).to_not be_empty
      end
    end

    context "no results" do
      include_context "no results"

      it "parses out the results" do
        expect(response.results).to be_empty
      end
    end
  end
end
