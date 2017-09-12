# frozen_string_literal: true
class Glosbe::Response
  attr_reader :ok, :body

  def initialize(body, ok:)
    @body = body
    @ok = !!ok
  end

  alias_method :ok?, :ok

  def from
    body["from"]
  end

  def to
    body["dest"]
  end

  def phrase
    body["phrase"]
  end

  def messages
    body["messages"] || []
  end

  def success?
    ok? && body["result"] == "ok"
  end

  def found?
    success? && results.any?
  end

  def results
    @results ||= begin
      if success? && body["tuc"].any?
        body["tuc"].map { |data| Glosbe::Result.new(data, authors: authors) }
      else
        []
      end
    end
  end

  def authors
    @authors ||= begin
      if success?
        body["authors"].map { |data| Glosbe::Author.new(data[1]) }
      else
        []
      end
    end
  end

  def translation
    result = results.find { |result| result.phrase }
    result.phrase if result
  end

  def define
    @define ||= extract_definitions_for(from)
  end

  def translated_define
    @translated_define ||= extract_definitions_for(to)
  end

  private

  def extract_definitions_for(language)
    results.map do |result|
      result.meanings.map do |meaning|
        meaning.text if meaning.language == language
      end
    end.flatten.compact
  end
end
