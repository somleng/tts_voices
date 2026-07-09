module TTSVoices
  class DataStore
    def load(type)
      case type
      when :all
        [
          DataSource::BasicVoices,
          DataSource::PollyVoices,
          DataSource::AzureVoices
        ].select do |voice|
          TTSVoices.configuration.voices.empty? || TTSVoices.configuration.voices.include?(voice.provider)
        end.flat_map(&:load_data)
      when :basic
        DataSource::BasicVoices.load_data
      when :azure
        DataSource::AzureVoices.load_data
      when :polly
        DataSource::PollyVoices.load_data
      end
    end
  end
end
