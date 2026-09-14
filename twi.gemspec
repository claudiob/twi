require_relative 'lib/twi/version'

Gem::Specification.new do |spec|
  spec.name = 'twi'
  spec.version = Twi::VERSION
  spec.authors = ['Claudio Baccigalupo']
  spec.email = ['claudiob@users.noreply.github.com']

  spec.summary = 'API Signature with timestamped MAC (Message Authentication Code).'
  spec.description = 'Enhances OpenSSL::HMAC with timestamp.'
  spec.homepage = 'https://github.com/claudiob/twi'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/claudiob/twi'
  spec.metadata['changelog_uri'] = 'https://github.com/claudiob/twi'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile Rakefile .gitignore test/ .github/])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'actionpack' # to read a webhook payload as ActionController::Parameters
  spec.add_dependency 'twilio-ruby' # to reach every Twilio endpoint this gem wraps

  spec.add_development_dependency 'minitest' # to run the test suite
  spec.add_development_dependency 'rake' # to run 'bundle exec rake'
  spec.add_development_dependency 'simplecov' # to report what the suite covers
  spec.add_development_dependency 'webmock' # to answer Twilio without a network
end
