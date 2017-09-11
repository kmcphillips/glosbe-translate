# frozen_string_literal: true
require "glosbe/version"

require "httparty"
require "cgi"
require "logger"

module Glosbe
  extend self
  attr_accessor :logger
  self.logger = Logger.new(nil)
end

require "glosbe/http"
require "glosbe/language_code"
require "glosbe/language"
require "glosbe/author"
require "glosbe/meaning"
require "glosbe/result"
require "glosbe/response"
