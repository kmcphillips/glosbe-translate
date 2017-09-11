# frozen_string_literal: true
class Glosbe::Language
  class << self
    def translate(phrase, args)
      from, to = extract_lanuages(args)
      self.new(from: from, to: to).translate(phrase)
    end

    private

    def extract_lanuages(args)
      raise ArgumentError, "expected hash but received #{args.class}" unless args.is_a?(Hash)

      if args.keys.sort == [:from, :to]
        [args[:from], args[:to]]
      elsif args.size == 1
        args.first
      else
        raise ArgumentError, "languages must be specified as `from: :aaa, to: :bbb` or `aaa: :bbb`"
      end
    end
  end

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

  def definitions(phrase)
    lookup(phrase).definitions
  end

  def translated_definitions(phrase)
    lookup(phrase).translated_definitions
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
