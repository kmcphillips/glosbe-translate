# frozen_string_literal: true
class Glosbe::HTTP
  attr_reader :body, :ok
  alias_method :ok?, :ok

  include HTTParty
  base_uri "https://glosbe.com/gapi"
  logger Glosbe.logger, :debug, :curl

  def initialize(from:, to:, phrase:)
    Glosbe.logger.debug("[Glosbe::HTTP] request from=#{from} to=#{to} phrase=#{phrase}")

    response = self.class.get("/translate",
      query: {
        from: from,
        dest: to,
        phrase: phrase,
        format: "json",
        pretty: "true",
      }
    )

    Glosbe.logger.debug("[Glosbe::HTTP] response code=#{response.code}")
    Glosbe.logger.debug("[Glosbe::HTTP] response body=#{response.body}")

    @ok = response.ok?
    @body = response.ok? || response.too_many_requests? ? response.parsed_response : nil
  end
end
