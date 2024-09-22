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
    cassette_path_segments = example.metadata[:file_path].sub(%r{.*/spec/}, '').sub('.rb', '').split(File::SEPARATOR)
    cassette_path = File.join(cassette_path_segments)

    case example.metadata
    in vcr: true
      vcr_overrides = {}
    in vcr: {**vcr_overrides}
      vcr_overrides[:record] = :new_episodes if vcr_overrides[:record] == true
    end

    vcr_overrides[:record] = :new_episodes if ENV['VCR_RECORD']

    VCR.use_cassette(cassette_path, vcr_overrides) { example.call }
  end
end
