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

  def success?
    ok? && body["result"] == "ok"
  end

  def found?
    success? && results.any?
  end

  def results
    success? ? body["tuc"] : []
  end
end
