# frozen_string_literal: true
class Glosbe::Language
  attr_reader :from, :to

  def initialize(from:, to:)
    @from = parse_language(from)
    @to = parse_language(to)
  end

  def lookup(phrase)
    http = Glosbe::HTTP.new(from: from, to: to, phrase: phrase)
    Glosbe::Response.new(http.body, ok: http.ok?)
  end

  def translate(phrase)
    lookup(phrase).translation
  end

  private

  def parse_language(value)
    value = value.to_s if value
    raise ArgumentError, "Language must be a string or a symbol. Received `#{ value }`." unless value.is_a?(String)
    raise ArgumentError, "Language must the 2 or 3 character ISO-639 code. Received `#{ value }`. "\
      "http://en.wikipedia.org/wiki/List_of_ISO_639-3_codes https://glosbe.com/all-languages" unless (2..3).include?(value.length)
    Glosbe::LanguageCode.normalize(value)
  end
end
