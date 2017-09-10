# frozen_string_literal: true
class Glosbe::HTTP
  attr_reader :body, :ok
  alias_method :ok?, :ok

  include HTTParty
  base_uri "https://glosbe.com/gapi"

  def initialize(from:, to:, phrase:)
    response = self.class.get("/translate",
      query: {
        from: from,
        dest: to,
        phrase: phrase,
        format: "json",
        pretty: "true",
      }
    )

    @ok = response.ok?
    @body = response.ok? ? response.parsed_response : nil
  end
end
