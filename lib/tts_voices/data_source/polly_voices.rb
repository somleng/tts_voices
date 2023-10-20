require "aws-sdk-polly"

module TTSVoices
  module DataSource
    class PollyVoices
      def self.load_data
        new.load_data
      end

      attr_reader :aws_client

      def initialize(aws_client: default_aws_client)
        @aws_client = aws_client
      end

      def load_data
        voices.each_with_object([]) do |voice, result|
          voice.supported_engines.each do |engine|
            result << Voice.new(
              provider: "Polly",
              name: voice.id,
              language: voice.language_code,
              gender: voice.gender,
              engine: engine.capitalize
            )
          end
        end
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
