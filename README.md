# TestOpenai

This gem is a personal exercise to get familiar with Ruby and Gem creating. gem Gem include only one top level namespace of TestOpenai which you can find all you need inside. Starting by creating an instance of TestOpenai::Client.

For this exercise, the client will provide wrapper to some of OpenAI File APIs. API doc can bbe found here:
- https://platform.openai.com/docs/api-reference/files

Other reference links:
- https://github.com/brendondaoateh/test_openai
- https://rubygems.org/gems/test_openai
- https://rubydoc.info/gems/test_openai

## Installation

You can install the gem normally through RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

    $ bundle add test_openai

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install test_openai

## Usage

Visit `spec/client_spec.rb` for full sample code

### Testing

- Copy file `.env.sample` to `.env` and fill in your personal OpenAI API's key
- Run
```
bundle install
rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/brendondaoateh/test_openai.
