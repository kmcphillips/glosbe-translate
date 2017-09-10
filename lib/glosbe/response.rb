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
end
