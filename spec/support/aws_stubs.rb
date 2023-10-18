Aws.config[:polly] ||= {
  stub_responses: {
    describe_voices: Aws::Polly::Client.new.stub_data(:describe_voices)
  }
}
