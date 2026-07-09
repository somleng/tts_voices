require "aws-sdk-polly"

module TTSVoices
  module DataSource
    class PollyVoices
      PROVIDER = "Polly".freeze

      attr_reader :aws_client

      def self.load_data
        new(TTSVoices.configuration.polly_options).load_data
      end

      def self.provider
        PROVIDER
      end

      def initialize(options = {})
        @aws_client = options.fetch(:aws_client) { Aws::Polly::Client.new(options) }
      end

      def load_data
        voices
          .flat_map { |voice| build_voices(voice) }
          .sort_by { |voice| [voice.language, voice.engine] }.reverse
      end

      private

      def raw_data
        @raw_data ||= aws_client.describe_voices
      end

      def voices
        raw_data.voices
      end

      def build_voices(voice)
        voice.supported_engines.map do |engine|
          engine_display_name = engine.capitalize

          Voice.new(
            provider: PROVIDER,
            name: voice.id,
            language: voice.language_code,
            gender: voice.gender,
            engine: engine_display_name,
            identifier: "#{PROVIDER}.#{voice.id}#{"-#{engine_display_name}" unless engine == "standard"}"
          )
        end
      end
    end
  end
end
