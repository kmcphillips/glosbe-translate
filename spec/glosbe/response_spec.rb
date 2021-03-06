# frozen_string_literal: true
require "spec_helper"

RSpec.describe Glosbe::Response do
  let(:response_success) do
    Glosbe::Response.new(response_for_cassette("translate_eng_fr_hello"), ok: true)
  end

  let(:response_success_small_result) do
    Glosbe::Response.new(response_for_cassette("translate_eng_fr_star"), ok: true)
  end

  let(:response_no_results) do
    Glosbe::Response.new(response_for_cassette("translate_eng_fr_xxxxx"), ok: true)
  end

  let(:response_success_medium_result) do
    Glosbe::Response.new(response_for_cassette("translate_fr_nl_enfant"), ok: true)
  end

  let(:response_bad_request) do
    Glosbe::Response.new("<html>Oh no!</html>", ok: false)
  end

  let(:response_too_many_requests) do
    Glosbe::Response.new(response_for_cassette("translate_too_many_requests"), ok: false)
  end

  describe "#initialize" do
    let(:body) { { key: "value" } }
    let(:response) { Glosbe::Response.new(body, ok: "yes") }

    it "passes in the body and the ok: param" do
      expect(response.body).to eq(body)
      expect(response.ok).to eq(true)
    end

    it "has a default value for the body" do
      expect(Glosbe::Response.new(nil, ok: "yes").body).to eq({})
    end
  end

  describe "#from" do
    it "on success parses the from out of the response" do
      expect(response_success.from).to eq("en")
    end

    it "on no results parses the from out of the response" do
      expect(response_no_results.from).to eq("en")
    end

    it "on bad request does not have anything to parse" do
      expect(response_bad_request.from).to be_nil
    end
  end

  describe "#to" do
    it "on success parses the to out of the response" do
      expect(response_success.to).to eq("fr")
    end

    it "on no results parses the to out of the response" do
      expect(response_no_results.to).to eq("fr")
    end

    it "on bad request does not have anything to parse" do
      expect(response_bad_request.to).to be_nil
    end
  end

  describe "#phrase" do
    it "on success parses the to out of the response" do
      expect(response_success.phrase).to eq("hello")
    end

    it "on success for a small result parses the to out of the response" do
      expect(response_success_small_result.phrase).to eq("*")
    end

    it "on no results parses the to out of the response" do
      expect(response_no_results.phrase).to eq("xxxxx")
    end

    it "on bad request does not have anything to parse" do
      expect(response_bad_request.phrase).to be_nil
    end
  end

  describe "#messages" do
    let(:message) { "oh hello" }

    it "passes through messages" do
      expect(Glosbe::Response.new({ "message" => message }, ok: true).message).to eq(message)
    end

    it "defaults to an empty array" do
      expect(Glosbe::Response.new({}, ok: true).message).to be_nil
    end

  end

  describe "#success?" do
    it "is false when ok: is false" do
      expect(Glosbe::Response.new({"result" => "ok"}, ok: false)).to_not be_success
    end

    it "is false when 'result' is not 'ok'" do
      expect(Glosbe::Response.new({"result" => "ohyes"}, ok: true)).to_not be_success
    end

    it "is true when both ok: is true and 'result' is ok" do
      expect(Glosbe::Response.new({"result" => "ok"}, ok: true)).to be_success
    end

    context "with real request data" do
      it "on success is true" do
        expect(response_success).to be_success
      end

      it "on no results is true" do
        expect(response_no_results).to be_success
      end

      it "on bad request is false" do
        expect(response_bad_request).to_not be_success
      end

      it "on too many requests is false" do
        expect(response_too_many_requests).to_not be_success
      end
    end
  end

  describe "#found?" do
    it "on success is true" do
      expect(response_success).to be_found
    end

    it "on no results is false" do
      expect(response_no_results).to_not be_found
    end

    it "on bad request is false" do
      expect(response_bad_request).to_not be_found
    end

    it "on too many requests is false" do
      expect(response_too_many_requests).to_not be_found
    end
  end

  describe "#message" do
    it "on success is empty" do
      expect(response_success.message).to be_nil
    end

    it "on no results is empty" do
      expect(response_no_results.message).to be_nil
    end

    it "on bad request is empty" do
      expect(response_bad_request.message).to be_nil
    end

    it "on too many requests has the error message" do
      expect(response_too_many_requests.message).to eq("Too many queries, your IP has been blocked")
    end
  end

  describe "#results" do
    context "on success" do
      it "has results" do
        expect(response_success.results).to_not be_empty
      end

      it "has results for a small set" do
        expect(response_success_small_result.results).to_not be_empty
      end
    end

    it "on no results is an empty array" do
      expect(response_no_results.results).to eq([])
    end

    it "on bad request is an empty array" do
      expect(response_bad_request.results).to eq([])
    end
  end

  describe "#authors" do
    context "on success" do
      it "has authors" do
        expect(response_success.authors).to_not be_empty
        expect(response_success.authors.first).to be_an_instance_of(Glosbe::Author)
      end

      it "has authors for a small set" do
        expect(response_success.authors).to_not be_empty
        expect(response_success.authors.first).to be_an_instance_of(Glosbe::Author)
      end
    end

    it "on no authors is an empty array" do
      expect(response_no_results.authors).to eq([])
    end

    it "on bad request is an empty array" do
      expect(response_bad_request.authors).to eq([])
    end
  end

  describe "#translation" do
    it "is the most first translated result" do
      expect(response_success.translation).to eq("salut")
    end

    it "handles no first translation" do
      expect(response_no_results.translation).to be_nil
    end

    it "handles no first phrase in the translation" do
      expect(response_success_small_result.translation).to be_nil
    end

    it "handles another translation between non english languages" do
      expect(response_success_medium_result.translation).to eq("kind")
    end
  end

  describe "#define" do
    it "extracts the definition in the :from language" do
      expect(response_success.define).to be_an_instance_of(Array)
      expect(response_success.define.length).to eq(29)
      expect(response_success.define.first).to eq("greeting")
    end

    it "handles bad results" do
      expect(response_success_small_result.define.length).to eq(2)
      expect(response_success_small_result.define.last).to eq("star")
    end
  end

  describe "#translated_define" do
    it "extracts the definition" do
      expect(response_success.translated_define).to be_an_instance_of(Array)
      expect(response_success.translated_define.length).to eq(6)
      expect(response_success.translated_define.first).to eq("Expression de salutation utilisée entre deux personnes ou plus qui se rencontrent.")
    end

    it "handles bad results" do
      expect(response_bad_request.translated_define).to eq([])
    end
  end

  context "using english to french 'hello'", vcr: { cassette_name: "translate_eng_fr_hello" } do
    let(:response) { Glosbe::Language.new(from: :en, to: :fr).lookup("hello") }

    it "extracts the expected authors" do
      expect(response.authors).to be_an_instance_of(Array)
      expect(response.authors.length).to eq(11)
      expect(response.authors.first.name).to eq("Termium")
    end
  end
end
