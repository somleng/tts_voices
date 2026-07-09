module TTSVoices
  class << self
    def data_store
      @data_store ||= reset_data_store!
    end

    def configure
      yield(configuration)
      configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end
    alias config configuration

    private

    def reset_data_store!
      @data_store = StoreCache.new(DataStore.new)
    end
  end
end

require_relative "tts_voices/version"
require_relative "tts_voices/configuration"
require_relative "tts_voices/voice"
require_relative "tts_voices/store_cache"
require_relative "tts_voices/data_store"
require_relative "tts_voices/data_source"
