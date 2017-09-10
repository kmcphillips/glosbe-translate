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
    it "extracts the expected fields" do
      result = Glosbe::Result.new(data[0], authors: authors)
      author = authors.find { |a| a.id == 14 }

      expect(result.phrase).to eq("salut")
      expect(result.language).to eq("fr")
      expect(result.authors).to eq([author])
    end

    it "extracts when the 'phrase' section is missing" do
      result = Glosbe::Result.new(data[21], authors: authors)
      author = authors.find { |a| a.id == 1 }

      expect(result.phrase).to be_nil
      expect(result.language).to be_nil
      expect(result.authors).to eq([author])
    end

    it "extracts meanings"
  end
end
