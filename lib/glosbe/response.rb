# frozen_string_literal: true
class Glosbe::Response
  attr_reader :from, :to, :phrase, :sources, :errors

  def initialize(http_response)
    @http = http_response
  end

  def from
    body["from"]
  end

  def to
    body["dest"]
  end

  def success?
    body["result"] == "ok"
  end

  def found?
    success? && results.any?
  end

  def results
    body["tuc"]
  end

  private

  def body
    @http.parsed_response
  end
end
