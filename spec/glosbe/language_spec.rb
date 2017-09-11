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
      expect(Glosbe::Language.new(from: :en, to: :fr).from).to eq("en")
    end

    it "accepts the string" do
      expect(Glosbe::Language.new(from: "fr", to: "nld").from).to eq("fr")
    end

    it "converts from symbol and shortened code" do
      expect(Glosbe::Language.new(from: :dut, to: :fr).from).to eq("nl")
    end
  end

  describe "#to" do
    it "converts from symbol" do
      expect(Glosbe::Language.new(from: :fr, to: :en).to).to eq("en")
    end

    it "accepts the string" do
      expect(Glosbe::Language.new(from: "nld", to: "fr").to).to eq("fr")
    end

    it "converts from symbol and shortened code" do
      expect(Glosbe::Language.new(from: :fr, to: :ger).to).to eq("de")
    end
  end

  describe "#lookup" do
    let(:language) { Glosbe::Language.new(from: :eng, to: :fr) }

    context "with HTTP requests and response to /translate" do
      context "success", vcr: { cassette_name: "translate_eng_fr_hello" } do
        let(:response) { language.lookup("hello") }

        it "creates a response object" do
          expect(response).to be_an_instance_of(Glosbe::Response)
          expect(response).to be_success
          expect(response.results).to_not be_empty
        end
      end

      context "no results", vcr: { cassette_name: "translate_eng_fr_xxxxx" } do
        let(:response) { language.lookup("xxxxx") }

        it "creates a response object" do
          expect(response).to be_an_instance_of(Glosbe::Response)
          expect(response).to be_success
          expect(response.results).to be_empty
        end
      end

      context "bad request", vcr: { cassette_name: "translate_bad_request" } do
        let(:response) { language.lookup("bad") }

        it "creates a response object" do
          expect(response).to be_an_instance_of(Glosbe::Response)
          expect(response).to_not be_success
          expect(response.results).to be_empty
        end
      end

      context "success small result", vcr: { cassette_name: "translate_eng_fr_star" } do
        let(:response) { language.lookup("*") }

        it "creates a response object" do
          expect(response).to be_an_instance_of(Glosbe::Response)
          expect(response).to be_success
          expect(response.results).to_not be_empty
        end
      end

      context "success medium request", vcr: { cassette_name: "translate_fr_nl_enfant"} do
        let(:language) { Glosbe::Language.new(from: :fr, to: :nl) }
        let(:response) { language.lookup("enfant") }

        it "creates a response object" do
          expect(response).to be_an_instance_of(Glosbe::Response)
          expect(response).to be_success
          expect(response.results).to_not be_empty
        end
      end
    end
  end

  describe "#translate" do
    context "english to french 'hello'", vcr: { cassette_name: "translate_eng_fr_hello" }  do
      it "translates to 'salut'" do
        expect(Glosbe::Language.new(from: :en, to: :fr).translate("hello")).to eq("salut")
      end
    end

    context "french to dutch 'enfant'", vcr: { cassette_name: "translate_fr_nl_enfant" }  do
      it "translates to 'kind'" do
        expect(Glosbe::Language.new(from: :fr, to: :nl).translate("enfant")).to eq("kind")
      end
    end

    context "without a result found", vcr: { cassette_name: "translate_eng_fr_star" }  do
      it "returns nil" do
        expect(Glosbe::Language.new(from: :en, to: :fr).translate("*")).to be_nil
      end
    end
  end

  describe "#definitions" do
    context "french to dutch 'enfant'", vcr: { cassette_name: "translate_fr_nl_enfant" }  do
      let(:language) { Glosbe::Language.new(from: :fr, to: :nl) }
      let(:definitions) { language.definitions("enfant") }

      it "returns the definitions in the :from language" do
        expect(definitions).to be_an_instance_of(Array)
        expect(definitions.length).to eq(4)
        expect(definitions.first).to eq("Entité ayant un sens plus restreint.")
      end
    end
  end

  describe "#translated_definitions" do
    context "english to french 'hello'", vcr: { cassette_name: "translate_eng_fr_hello" }  do
      let(:language) { Glosbe::Language.new(from: :en, to: :fr) }
      let(:definitions) { language.translated_definitions("hello") }

      it "returns the definitions in the :from language" do
        expect(definitions).to be_an_instance_of(Array)
        expect(definitions.length).to eq(6)
        expect(definitions.first).to eq("Expression de salutation utilisée entre deux personnes ou plus qui se rencontrent.")
      end
    end
  end

  describe ".translate" do
    context "english to french 'hello'", vcr: { cassette_name: "translate_eng_fr_hello" }  do
      it "translates to 'salut'" do
        expect(Glosbe::Language.translate("hello", from: :en, to: :fr)).to eq("salut")
      end
    end

    context "french to dutch 'enfant'", vcr: { cassette_name: "translate_fr_nl_enfant" }  do
      it "translates to 'kind'" do
        expect(Glosbe::Language.translate("enfant", from: :fr, to: :nl)).to eq("kind")
      end
    end

    context "without a result found", vcr: { cassette_name: "translate_eng_fr_star" }  do
      it "returns nil" do
        expect(Glosbe::Language.translate("*", from: :en, to: :fr)).to be_nil
      end
    end
  end
end
