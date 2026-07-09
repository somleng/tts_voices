module TTSVoices
  class Configuration
    attr_accessor :voices, :polly_options, :azure_options

    def initialize(options = {})
      @voices = Array(options[:voices])
      @polly_options = Hash(options[:polly_options])
      @azure_options = Hash(options[:azure_options])
    end
  end
end
