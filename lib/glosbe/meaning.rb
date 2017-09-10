# frozen_string_literal: true
class Glosbe::Meaning
  attr_reader :language, :text

  def initialize(data)
    @language = data["language"]
    @text = data["text"]
  end
end
