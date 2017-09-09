module CassetteHelpers
  def response_for_cassette(cassette)
    VCR.use_cassette(cassette) do
      JSON.parse(VCR.current_cassette.http_interactions.interactions.first.response.body)
    end
  end
end
