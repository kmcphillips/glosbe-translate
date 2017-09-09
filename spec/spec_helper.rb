# frozen_string_literal: true
require "bundler/setup"
require "glosbe/translate"

require "pry"

require "vcr"
require "webmock/rspec"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.extend VCR::RSpec::Macros
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
end

WebMock.disable_net_connect!(allow_localhost: true)
