Aws.config[:polly] ||= {
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
}
