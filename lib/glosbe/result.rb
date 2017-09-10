# frozen_string_literal: true
class Glosbe::Result
  attr_reader :phrase, :language, :authors, :meanings

  def initialize(data, authors: [])
    if data["phrase"]
      @phrase = data["phrase"]["text"]
      @language = data["phrase"]["language"]
    end
    @authors = authors.select do |author|
      data["authors"].include?(author.id)
    end
    @meanings = (data["meanings"] || []).map { |meaning| Glosbe::Meaning.new(meaning) }
  end
end
