module TTSVoices
  class << self
    def data_store
      @data_store ||= reset_data_store!
    end

    private

    def reset_data_store!
      @data_store = StoreCache.new(DataStore.new)
    end
  end
end

require_relative "tts_voices/version"
require_relative "tts_voices/store_cache"
require_relative "tts_voices/data_store"
require_relative "tts_voices/data_source"
require_relative "tts_voices/voice"
