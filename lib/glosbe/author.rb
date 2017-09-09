# frozen_string_literal: true
class Glosbe::Author
  attr_reader :id, :name, :source, :url

  def initialize(data)
    @id = data["id"]
    @name = data["N"]
    @source = data["U"]
    @url = data["url"]
  end
end
