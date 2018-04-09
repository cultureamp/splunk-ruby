# splunk-ruby
Ruby gem for logging to splunk conforming to sensible defaults

## Installation
Put this in your `Gemfile`
```ruby
gem 'splunk-logger', github: 'cultureamp/splunk-ruby'
```

## Use
You can use it directly such as
```ruby
logger = Logger.new(STDOUT, progname: 'my-cool-app')
splunk_logger = Splunk::Logger.new(logger)

splunk_logger.log('foo')
#=> severity=INFO _time=2018-04-09T15:10:44+10:00 pid=12345 progname=my-cool-app message=foo
```
Or you can use the formatter on your existing logger
```ruby
logger = Logger.new(STDOUT, progname: 'my-cool-app', formatter: Splunk::Logger::LogfmtFormatter.new)
logger.info('foo')
#=> severity=INFO _time=2018-04-09T15:10:44+10:00 pid=12345 progname=my-cool-app message=foo
```
