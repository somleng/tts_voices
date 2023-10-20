require "spec_helper"

module TTSVoices
  module DataSource
    RSpec.describe PollyVoices do
      it "loads Polly voices" do
        fake_client = build_fake_polly_client
        voices = PollyVoices.new(aws_client: fake_client).load_data

        expect(voices.size).to eq(2)
        expect(voices[0]).to have_attributes(
          gender: "Female",
          name: "Vitoria",
          language: "pt-BR",
          provider: "Polly",
          engine: "Neural"
        )
        expect(voices[1]).to have_attributes(
          gender: "Female",
          name: "Vitoria",
          language: "pt-BR",
          provider: "Polly",
          engine: "Standard"
        )
      end

      def build_fake_polly_client
        Aws::Polly::Client.new(
          stub_responses: {
            describe_voices: {
              voices: [
                {
                  gender: "Female", id: "Vitoria", language_code: "pt-BR",
                  supported_engines: %w[neural standard]
                }
              ]
            }
          }
        )
      end
    end
  end
end
