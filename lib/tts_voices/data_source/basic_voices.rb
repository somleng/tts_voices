module TTSVoices
  module DataSource
    class BasicVoices
      DATA = {
        "Kal" => { "language" => "en-US", "gender" => "Male" },
        "Slt" => { "language" => "en-US", "gender" => "Female" }
      }.freeze

      def self.load_data
        new.load_data
      end

      def load_data
        DATA.each_with_object([]) do |(voice, attributes), result|
          result << Voice.new(
            provider: "Basic",
            name: voice,
            language: attributes.fetch("language"),
            gender: attributes.fetch("gender")
          )
        end
      end
    end
  end
end
