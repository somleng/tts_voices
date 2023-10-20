require "spec_helper"

module TTSVoices
  module DataSource
    RSpec.describe PollyVoices do
      it "loads Polly voices" do
        fake_client = build_fake_polly_client
        voices = PollyVoices.new(aws_client: fake_client).load_data

        expect(voices.size).to eq(3)

        expect(voices[0]).to have_attributes(
          gender: "Female",
          name: "Ivy",
          language: "en-US",
          provider: "Polly",
          engine: "Standard"
        )
        expect(voices[1]).to have_attributes(
          gender: "Female",
          name: "Ivy",
          language: "en-US",
          provider: "Polly",
          engine: "Neural"
        )
        expect(voices[2]).to have_attributes(
          gender: "Female",
          name: "Danielle",
          language: "en-US",
          provider: "Polly",
          engine: "Neural"
        )
      end

      def build_fake_polly_client
        Aws::Polly::Client.new(
          stub_responses: {
            describe_voices: {
              voices: [
                {
                  gender: "Female", id: "Danielle", language_code: "en-US",
                  supported_engines: %w[neural]
                },
                {
                  gender: "Female", id: "Ivy", language_code: "en-US",
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
