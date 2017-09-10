# frozen_string_literal: true
class Glosbe::Result
  attr_reader :phrase, :language, :authors

  def initialize(data, authors: [])
    if data["phrase"]
      @phrase = data["phrase"]["text"]
      @language = data["phrase"]["language"]
    end
    @authors = authors.select do |author|
      data["authors"].include?(author.id)
    end
  end
end
