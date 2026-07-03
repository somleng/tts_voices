require "spec_helper"

module TTSVoices
  module DataSource
    RSpec.describe BasicVoices do
      it "loads Basic voices" do
        voices = BasicVoices.new.load_data

        expect(voices.size).to eq(2)
        expect(voices.first).to have_attributes(
          gender: "Male",
          identifier: "Basic.Kal",
          name: "Kal",
          language: "en-US",
          provider: "Basic",
          engine: "Standard"
        )
      end
    end
  end
end
