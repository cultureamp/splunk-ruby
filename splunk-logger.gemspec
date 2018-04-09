Gem::Specification.new do |s|
  s.name        = 'splunk-logger'
  s.version     = '0.0.0'
  s.date        = '2018-04-09'
  s.summary     = 'Splunk Log Formatting'
  s.description = 'Ruby gem for logging to splunk conforming to sensible defaults'
  s.authors     = ['Rob Jacoby']
  s.email       = 'robert.jacoby@cultureamp.com'
  s.files       = `git ls-files -- lib/*`.split("\n")
  s.files      += %w[README.md]
  s.homepage    = 'https://github.com/cultureamp/splunk-ruby'

  s.add_development_dependency "rspec", "~> 3.7"
end
