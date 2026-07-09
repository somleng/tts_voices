require "vcr"
require "webmock/rspec"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data("<AZURE_SPEECH_KEY>") { ENV["AZURE_SPEECH_KEY"] }
end
