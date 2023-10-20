module TTSVoices
  class Voice
    DEFAULT_IDENTIFIER = "Basic.Kal".freeze

    class << self
      def all
        data_store.load(:all)
      end

      def basic
        data_store.load(:basic)
      end

      def polly
        data_store.load(:polly)
      end

      def find(identifier)
        all.find { |voice| voice.identifier == identifier }
      end

      def default
        find(DEFAULT_IDENTIFIER)
      end

      private

      def data_store
        TTSVoices.data_store
      end
    end

    attr_reader :name, :gender, :language, :provider, :engine

    def initialize(name:, gender:, language:, provider:, engine:)
      @name = name
      @gender = gender
      @language = language
      @provider = provider
      @engine = engine
    end

    def to_s
      "#{identifier} (#{gender}, #{language})"
    end

    def identifier
      "#{provider}.#{name}#{"-#{engine}" unless engine == "Standard"}"
    end
  end
end
