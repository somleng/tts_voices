require "spec_helper"

module TTSVoices
  module DataSource
    RSpec.describe AzureVoices do
      FakeResponse = Data.define(:code, :message, :body)

      class FakeHTTPClient
        attr_reader :last_request

        def initialize(response)
          @response = response
        end

        def start(_host, _port, use_ssl:)
          @use_ssl = use_ssl
          yield self
        end

        def request(request)
          @last_request = request
          @response
        end
      end

      it "loads Azure voices" do
        VCR.use_cassette("azure_voices") do
          voices = AzureVoices.load_data

          expect(voices.map(&:identifier)).to include(
            "Azure.km-KH-PisethNeural",
            "Azure.es-MX-BeatrizNeural"
          )
        end
      end

      it "configures with options" do
        allow(TTSVoices.configuration).to receive(:azure_options).and_return({
          region: "southeastasia",
          key: "1234567890"
        })

        VCR.use_cassette("azure_voices") do
          AzureVoices.load_data

          expect(WebMock).to have_requested(
            :get,
            "https://southeastasia.tts.speech.microsoft.com/cognitiveservices/voices/list"
          ).with(headers: { "Ocp-Apim-Subscription-Key" => "1234567890" })
        end
      end

      it "raises when the Azure request fails" do
        client = build_client(FakeResponse.new("401", "Unauthorized", ""))

        expect do
          client.fetch_voices
        end.to raise_error(AzureVoices::Error, /Unauthorized/)
      end

      it "raises when the Azure response is invalid JSON" do
        client = build_client(FakeResponse.new("200", "OK", "{invalid-json}"))

        expect do
          client.fetch_voices
        end.to raise_error(AzureVoices::Error, /invalid JSON/)
      end

      def build_client(response)
        fake_http_client = FakeHTTPClient.new(response)
        AzureVoices::Client.new(http_client: fake_http_client)
      end
    end
  end
end
