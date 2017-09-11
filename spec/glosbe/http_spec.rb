# frozen_string_literal: true
require "spec_helper"

RSpec.describe Glosbe::HTTP do
  describe "#initialize" do
    context "success", vcr: { cassette_name: "translate_eng_fr_hello" } do
      let(:http) { Glosbe::HTTP.new(from: "en", to: "fr", phrase: "hello") }

      it "looks up passed in values" do
        expect(http).to be_ok
        expect(http.body).to be_an_instance_of(Hash)
      end

      it "logs to the global logger" do
        expect(Glosbe.logger).to receive(:debug)
        http
      end
    end

    context "bad request", vcr: { cassette_name: "translate_bad_request" } do
      let(:http) { Glosbe::HTTP.new(from: "en", to: "fr", phrase: "bad") }

      it "only parses the response on success" do
        expect(http).to_not be_ok
        expect(http.body).to be_nil
      end
    end
  end
end
