# frozen_string_literal: true
class Glosbe::Language
  include HTTParty
  base_uri "https://glosbe.com/gapi"

  attr_reader :from, :to

  def initialize(from:, to:)
    @from = parse_language(from)
    @to = parse_language(to)
  end

  def response(phrase)
    http = self.class.get("/translate", query: query_for(phrase))
    body = http.ok? ? http.parsed_response : nil

    Glosbe::Response.new(body, ok: http.ok?)
  end

  private

  def query_for(phrase)
    {
      from: from,
      dest: to,
      phrase: phrase,
      format: "json",
      pretty: "true",
    }
  end

  def parse_language(value)
    value = value.to_s if value.is_a?(Symbol)
    raise ArgumentError, "Language must be a string or a symbol. Received `#{ value }`." unless value.is_a?(String)
    raise ArgumentError, "Language must the 2 or 3 character ISO_639-3 code. Received `#{ value }`. "\
      "http://en.wikipedia.org/wiki/List_of_ISO_639-3_codes https://glosbe.com/all-languages" unless (2..3).include?(value.length)
    value
  end
end
