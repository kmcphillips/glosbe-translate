# frozen_string_literal: true
require "spec_helper"

RSpec.describe Glosbe::Meaning do
  let(:data) { response_for_cassette("translate_eng_fr_hello")["tuc"][21]["meanings"].first }
  let(:meaning) { Glosbe::Meaning.new(data) }

  describe "#initialize" do
    it "extracts the language and text" do
      expect(meaning.language).to eq("en")
      expect(meaning.text).to eq("&quot;Hello!&quot; or an equivalent greeting.")
    end
  end
end
