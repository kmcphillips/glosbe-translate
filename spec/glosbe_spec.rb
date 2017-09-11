# frozen_string_literal: true
require "spec_helper"

RSpec.describe Glosbe do
  it "has a version number" do
    expect(Glosbe::VERSION).not_to be nil
  end

  describe ".logger" do
    it "has a default logger instance" do
      expect(Glosbe.logger).to be_an_instance_of(::Logger)
    end

    it "allows the logger to be overwritten" do
      begin
        original = Glosbe.logger
        logger = Logger.new("/dev/null")
        Glosbe.logger = logger
        expect(logger).to receive(:info).with("a message")
        Glosbe.logger.info("a message")
      ensure
        Glosbe.logger = original
      end
    end
  end
end
