require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.ignore_localhost = true
  config.ignore_hosts "chromedriver.storage.googleapis.com"
  config.default_cassette_options = {
    record: :once,
    match_requests_on: %i[method host path query]
  }
end

RSpec.configure do |config|
  config.around(:each, :vcr) do |example|
    cassette_path_segments = example.metadata[:file_path].split(File::SEPARATOR)
    cassette_path_segments[-1].sub!('.rb', '')
    cassette_path_segments = cassette_path_segments.drop(cassette_path_segments.index('spec').next)
    cassette_path = File.join(cassette_path_segments)

    options = example.metadata.slice(:record, :match_requests_on)
    options[:record] = :new_episodes if ENV['VCR_RECORD'] || options[:record] == true

    VCR.use_cassette(cassette_path, options) do
      example.call
    end
  end
end
