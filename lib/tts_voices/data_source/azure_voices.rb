require "json"
require "net/http"
require "uri"

module TTSVoices
  module DataSource
    class AzureVoices
      PROVIDER = "Azure".freeze

      class Error < StandardError; end

      class Voice < TTSVoices::Voice
        def to_s
          "#{PROVIDER}.#{name}#{"-#{engine}" unless engine == "Standard"} (#{gender}, #{language})"
        end
      end

      class Client
        attr_reader :region, :key, :http_client

        def initialize(options = {})
          @region = options.fetch(:region) { ENV.fetch("AZURE_SPEECH_REGION", "southeastasia") }
          @key = options.fetch(:key) { ENV["AZURE_SPEECH_KEY"] }
          @http_client = options.fetch(:http_client) { Net::HTTP }
        end

        def fetch_voices
          uri = URI("https://#{region}.tts.speech.microsoft.com/cognitiveservices/voices/list")
          request = Net::HTTP::Get.new(uri)
          request["Ocp-Apim-Subscription-Key"] = key

          response = http_client.start(uri.host, uri.port, use_ssl: true) do |http|
            http.request(request)
          end

          unless response.code.to_i.between?(200, 299)
            raise Error, "Azure Speech voices request failed: #{response.code} #{response.message}"
          end

          JSON.parse(response.body)
        rescue JSON::ParserError => e
          raise Error, "Azure Speech voices response was invalid JSON: #{e.message}"
        end
      end

      def self.load_data
        new.load_data
      end

      def initialize(client: default_client)
        @client = client
      end

      def load_data
        client
          .fetch_voices
          .map { |voice_attributes| build_voice(voice_attributes) }
          .sort_by { |voice| [voice.language, voice.engine, voice.name] }
      end

      private

      def default_client
        Client.new
      end

      def client
        @client ||= default_client
      end

      def build_voice(attributes)
        Voice.new(
          provider: PROVIDER,
          identifier: "#{PROVIDER}.#{attributes.fetch("ShortName")}",
          name: attributes.fetch("DisplayName"),
          language: attributes.fetch("Locale"),
          gender: attributes.fetch("Gender"),
          engine: attributes.fetch("VoiceType")
        )
      end
    end
  end
end
