# frozen_string_literal: true
require "spec_helper"

RSpec.describe Glosbe::LanguageCode do
  describe "#normalize" do
    it "converts to string for unknown codes" do
      expect(Glosbe::LanguageCode.normalize(:xx)).to eq("xx")
    end

    it "converts to string for known codes" do
      expect(Glosbe::LanguageCode.normalize(:es)).to eq("es")
    end

    it "converts three character to two character" do
      expect(Glosbe::LanguageCode.normalize("nld")).to eq("nl")
      expect(Glosbe::LanguageCode.normalize("eng")).to eq("en")
      expect(Glosbe::LanguageCode.normalize("ger")).to eq("de")
    end

    it "passes through unknown three character" do
      expect(Glosbe::LanguageCode.normalize("xx")).to eq("xx")
    end

    it "passes through known two character" do
      expect(Glosbe::LanguageCode.normalize("fi")).to eq("fi")
    end

    it "passes through unknown two character" do
      expect(Glosbe::LanguageCode.normalize("zz")).to eq("zz")
    end

    it "converts languages with more than one three letter code" do
      expect(Glosbe::LanguageCode.normalize("mao")).to eq("mi")
      expect(Glosbe::LanguageCode.normalize("mri")).to eq("mi")
    end

    it "passes through nil" do
      expect(Glosbe::LanguageCode.normalize(nil)).to be_nil
    end
  end
end
