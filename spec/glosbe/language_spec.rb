# frozen_string_literal: true
require "spec_helper"

RSpec.describe Glosbe::Language do
  describe "#initialize" do
    it "raises without :from passed in" do
      expect{ Glosbe::Language.new(to: "eng") }.to raise_error(ArgumentError)
    end

    it "raises without :to passed in" do
      expect{ Glosbe::Language.new(from: "eng") }.to raise_error(ArgumentError)
    end

    it "accepts three character strings" do
      expect{ Glosbe::Language.new(from: "eng", to: "nld") }.to_not raise_error
    end

    it "accepts two character strings" do
      expect{ Glosbe::Language.new(from: "en", to: "fr") }.to_not raise_error
    end

    it "does not accept one character strings" do
      expect{ Glosbe::Language.new(from: "e", to: "f") }.to raise_error(ArgumentError)
    end

    it "does not accept four character strings" do
      expect{ Glosbe::Language.new(from: "aaaa", to: "bbbb") }.to raise_error(ArgumentError)
    end

    it "accepts symbols" do
      expect{ Glosbe::Language.new(from: :en, to: :nld) }.to_not raise_error
    end

    it "does not accept objects" do
      expect{ Glosbe::Language.new(from: Object.new, to: Object.new) }.to raise_error(ArgumentError)
    end

    it "does not nil" do
      expect{ Glosbe::Language.new(from: nil, to: nil) }.to raise_error(ArgumentError)
    end
  end

  describe "#from" do
    it "converts from symbol" do
      expect(Glosbe::Language.new(from: :eng, to: :fr).from).to eq("eng")
    end

    it "accepts the string" do
      expect(Glosbe::Language.new(from: "fr", to: "nld").from).to eq("fr")
    end
  end

  describe "#to" do
    it "converts from symbol" do
      expect(Glosbe::Language.new(from: :fr, to: :eng).to).to eq("eng")
    end

    it "accepts the string" do
      expect(Glosbe::Language.new(from: "nld", to: "fr").to).to eq("fr")
    end
  end
end
