# frozen_string_literal: true
require "spec_helper"

RSpec.describe Glosbe::Author do
  let(:data) { response_for_cassette("translate_eng_fr_hello")["authors"].first[1] }

  describe "#initialize" do
    let(:author) { Glosbe::Author.new(data) }

    it "extracts the expected fields" do
      expect(author.id).to eq(80097)
      expect(author.name).to eq("Termium")
      expect(author.source).to eq("http://www.btb.termiumplus.gc.ca/")
      expect(author.url).to eq("https://glosbe.com/source/80097")
    end
  end
end
