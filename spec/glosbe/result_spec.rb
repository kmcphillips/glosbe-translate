# frozen_string_literal: true
require "spec_helper"

RSpec.describe Glosbe::Result do
  let(:data) { response_for_cassette("translate_eng_fr_hello")["tuc"] }
  let(:authors) do
    response_for_cassette("translate_eng_fr_hello")["authors"].map do |author_data|
      Glosbe::Author.new(author_data[1])
    end
  end

  describe "#initialize" do
    context "first definition" do
      let(:result) { Glosbe::Result.new(data[0], authors: authors) }
      let(:author) { authors.find { |a| a.id == 14 } }

      it "extracts the expected fields" do
        expect(result.phrase).to eq("salut")
        expect(result.language).to eq("fr")
        expect(result.authors).to eq([author])
      end
    end

    context "simpler definition" do
      let(:result) { Glosbe::Result.new(data[21], authors: authors) }
      let(:author) { authors.find { |a| a.id == 1 } }

      it "extracts when the 'phrase' section is missing" do
        expect(result.phrase).to be_nil
        expect(result.language).to be_nil
        expect(result.authors).to eq([author])
      end

      it "extracts meanings" do
        expect(result.meanings.size).to eq(1)
        expect(result.meanings.first).to be_an_instance_of(Glosbe::Meaning)
      end
    end

    context "no meanings" do
      let(:result) { Glosbe::Result.new(data[11], authors: authors) }
      let(:author) { authors.find { |a| a.id == 80097 } }

      it "has an empty set of meanings" do
        expect(result.meanings).to eq([])
      end

      it "handles special characters" do
        expect(result.phrase).to eq("j'écoute")
      end
    end
  end
end
