require "aws-sdk-polly"

module TTSVoices
  module DataSource
    class PollyVoices
      PROVIDER = "Polly".freeze

      def self.load_data
        new.load_data
      end

      attr_reader :aws_client

      def initialize(aws_client: default_aws_client)
        @aws_client = aws_client
      end

      def load_data
        result = voices.each_with_object([]) do |voice, result|
          voice.supported_engines.each do |engine|
            engine_display_name = engine.capitalize

            result << Voice.new(
              provider: PROVIDER,
              name: voice.id,
              language: voice.language_code,
              gender: voice.gender,
              engine: engine_display_name,
              identifier: "#{PROVIDER}.#{voice.id}#{"-#{engine_display_name}" unless engine == "standard"}"
            )
          end
        end
        result.sort_by { |voice| [voice.language, voice.engine] }.reverse
      end

      private

      def default_aws_client
        Aws::Polly::Client.new
      end

      def raw_data
        @raw_data ||= aws_client.describe_voices
      end

      def voices
        raw_data.voices
      end
    end
  end
end
