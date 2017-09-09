# frozen_string_literal: true
class Glosbe::Response
  def initialize(http_response)
    @http = http_response
  end
end
