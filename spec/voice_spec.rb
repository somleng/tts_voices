require "spec_helper"

module TTSVoices
  RSpec.describe Voice do
    it "returns a default voice" do
      voice = Voice.default

      expect(voice.identifier).to eq("Basic.Kal")
    end

    it "finds by the identifier" do
      voice = Voice.find("Basic.Kal")

      expect(voice.identifier).to eq("Basic.Kal")
    end

    it "returns a string representation" do
      voice = Voice.default

      expect(voice.to_s).to eq("Basic.Kal (Male, en-US)")
    end

    it "returns a string representation for Neural voices" do
      voice = Voice.find("Polly.Vitoria-Neural")

      expect(voice.to_s).to eq("Polly.Vitoria-Neural (Female, pt-BR)")
    end
  end
end
