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
        response = FakeResponse.new("200", "OK", JSON.dump([
          {
            "ShortName" => "en-US-GuyNeural",
            "DisplayName" => "Guy",
            "Gender" => "Male",
            "Locale" => "en-US",
            "VoiceType" => "Neural"
          },
          {
            "ShortName" => "en-GB-LibbyNeural",
            "DisplayName" => "Libby",
            "Gender" => "Female",
            "Locale" => "en-GB",
            "VoiceType" => "Neural"
          }
        ]))
        fake_http_client = FakeHTTPClient.new(response)
        fake_client = AzureVoices::Client.new(region: "southeastasia", key: "api-key", http_client: fake_http_client)

        voices = AzureVoices.new(client: fake_client).load_data

        expect(voices.map(&:identifier)).to eq([
          "Azure.en-GB-LibbyNeural",
          "Azure.en-US-GuyNeural",
        ])
        expect(voices[0]).to have_attributes(
          identifier: "Azure.en-GB-LibbyNeural",
          name: "Libby",
          language: "en-GB",
          engine: "Neural",
          gender: "Female"
        )
        expect(voices[1]).to have_attributes(
          identifier: "Azure.en-US-GuyNeural",
          name: "Guy"
        )

        expect(fake_http_client.last_request["Ocp-Apim-Subscription-Key"]).to eq("api-key")
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
        AzureVoices::Client.new(region: "southeastasia", key: "api-key", http_client: fake_http_client)
      end
    end
  end
end
