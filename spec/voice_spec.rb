require "spec_helper"

module TTSVoices
  RSpec.describe Voice do
    around do |example|
      VCR.use_cassette("azure_voices") do
        example.run
      end
    end

    it "returns a default voice" do
      voice = Voice.default

      expect(voice.identifier).to eq("Basic.Kal")
    end

    it "finds by the identifier" do
      basic_voice = Voice.find("Basic.Kal")
      azure_voice = Voice.find("Azure.af-ZA-WillemNeural")


      expect(basic_voice.identifier).to eq("Basic.Kal")
      expect(azure_voice.identifier).to eq("Azure.af-ZA-WillemNeural")
    end

    it "returns a string representation" do
      voice = Voice.default

      expect(voice.to_s).to eq("Basic.Kal (Male, en-US)")
    end

    it "returns a string representation for Neural voices" do
      polly_voice = Voice.find("Polly.Vitoria-Neural")
      azure_voice = Voice.find("Azure.af-ZA-WillemNeural")

      expect(polly_voice.to_s).to eq("Polly.Vitoria-Neural (Female, pt-BR)")
      expect(azure_voice.to_s).to eq("Azure.Willem-Neural (Male, af-ZA)")
    end
  end
end
