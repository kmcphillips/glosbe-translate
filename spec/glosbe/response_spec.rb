# frozen_string_literal: true
require "spec_helper"

RSpec.describe Glosbe::Response do
  shared_context "success" do
    use_vcr_cassette "translate_eng_fr_hello"

    let(:language) { Glosbe::Language.new(from: :eng, to: :fr) }
    let(:response) { language.response("hello") }
  end

  describe "#initialize" do
    it "should be tested"
  end

  describe "#from" do
    include_context "success"

    it "parses the from out of the response" do
      expect(response.from).to eq("en")
    end
  end

  describe "#to" do
    include_context "success"

    it "parses the to out of the response" do
      expect(response.to).to eq("fr")
    end
  end

  describe "#success?" do
    include_context "success"

    it "looks at the result" do
      expect(response.success?).to eq(true)
    end
  end

  describe "#found?" do
    include_context "success"

    it "looks at the success and number of results" do
      expect(response.found?).to eq(true)
    end

    it "with no results found"
  end

  describe "#results" do
    include_context "success"

    it "parses out the results" do
      expect(response.results).to_not be_empty
    end

    it "parses the results"
  end
end
