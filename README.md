# TTSVoices

[![Build](https://github.com/somleng/tts_voices/actions/workflows/main.yml/badge.svg)](https://github.com/somleng/tts_voices/actions/workflows/main.yml)

A collection of TTS voices used in Somleng

## Usage

```rb
TTSVoices::Voice.all # List all voices
# => [#<TTSVoices::Voice:0x0000000106e26420 @engine="Standard", @gender="Male", @language="en-US", @name="Kal", @provider="Basic">,
# ...
# #<TTSVoices::Voice:0x0000000106de5b50 @engine="Neural", @gender="Male", @language="ar-AE", @name="Zayd", @provider="Polly">]

voice = TTSVoices::Voice.default # Default voice
# => #<TTSVoices::Voice:0x0000000106e26420 @engine="Standard", @gender="Male", @language="en-US", @name="Kal", @provider="Basic">
voice.identifier
# => "Basic.Kal"
voice.to_s
# => "Basic.Kal (Male, en-US)"

voice = TTSVoices::Voice.find("Polly.Joanna") # Find a voice by id
=> #<TTSVoices::Voice:0x0000000106de6960 @engine="Standard", @gender="Female", @language="en-US", @name="Joanna", @provider="Polly">
voice.identifier
# => "Polly.Joanna"
voice.to_s
# => "Polly.Joanna (Female, en-US)"

voice = TTSVoices::Voice.find("Polly.Hala-Neural") # Find a neural voice by id
# => #<TTSVoices::Voice:0x0000000106de60f0 @engine="Neural", @gender="Female", @language="ar-AE", @name="Hala", @provider="Polly">
voice.identifier
# => "Polly.Hala-Neural"
# "Polly.Hala-Neural (Female, ar-AE)"
```

Read [the specs](https://github.com/somleng/tts_voices/tree/main/spec) for more usage examples.

## Providers

In order to load AWS Polly voices the following IAM policy is required.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "polly:DescribeVoices"
      ],
      "Resource": "*"
    }
  ]
}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/somleng/tts_voices.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
