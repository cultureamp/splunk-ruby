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

splunk_logger.log({ foo: 'bar' })
#=> severity=INFO _time=2018-04-09T15:10:44+10:00 pid=12345 progname=my-cool-app foo=bar
```
Or you can use the formatter on your existing logger
```ruby
logger = Logger.new(STDOUT, progname: 'my-cool-app', formatter: Splunk::Logger::LogfmtFormatter.new)
logger.debug({ foo: 'bar' })
#=> severity=DEBUG _time=2018-04-09T15:10:44+10:00 pid=12345 progname=my-cool-app message=foo
```

**The log formatter will only accept instances of `Hash`, `Array`, and `Exception`.** 

`Array`s need to have an even number of values (so it can be parsed into `key=value` pairs)

You can also use the formatter to parse the above directly

```ruby
Splunk::Logger::LogfmtFormatter.from_hash({ foo: 'bar' })
#=> "foo=bar"

Splunk::Logger::LogfmtFormatter.from_exception(Exception.new('Bad Error'))
#=> "error=\"Bad Error\" file=/path/to/file line=123 function=bad_method"

Splunk::Logger::LogfmtFormatter.from_array(%w(foo bar baz beef))
#=> "foo=bar baz=beef"
```
