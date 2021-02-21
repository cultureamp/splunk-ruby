require 'splunk/logger/logfmt_formatter'

RSpec.describe Splunk::Logger::LogfmtFormatter do
  PREFIX = 'severity=INFO _time=[0-9\-T:+]+ pid=\d+ progname=splunk-ruby'.freeze
  let(:severity) { 'INFO' }
  let(:time) { Time.now }
  let(:progname) { 'splunk-ruby' }
  let(:formatter) { Splunk::Logger::LogfmtFormatter.new }

  describe '#call' do
    context 'when passed a string' do
      it 'raises an exception' do
        expect { formatter.call(severity, time, progname, 'foo') }.to raise_error(ArgumentError)
      end
    end

    context 'when passed an array of strings' do
      context 'when the array size is even' do
        it 'logs the values as key=value to the logger via info' do
          expect(formatter.call(severity, time, progname, %w(foo bar))).to match(/\A#{PREFIX} foo=bar\n\z/)
        end
      end

      context 'when the array size is odd' do
        it 'raises an exception' do
          expect { formatter.call(severity, time, progname, %w(foo bar baz)) }.to raise_error(ArgumentError)
        end
      end
    end

    context 'when passed a hash' do
      it 'logs keys and values in logfmt to the logger via info' do
        expect(formatter.call(severity, time, progname, foo: 'bar')).to match(/\A#{PREFIX} foo=bar\n\z/)
      end
    end

    context 'when passed a nested hash' do
      it 'raises an exception' do
        expect { formatter.call(severity, time, progname, foo: { bar: 'baz' }) }.to raise_error(ArgumentError)
      end
    end

    context 'when passed an exception' do
      context 'with a backtrace' do
        it 'logs the exception details in logfmt to the logger via info' do
          exception = Exception.new('Bad Error')
          exception.set_backtrace(["/var/lib/oops:123:in `nope'"])
          expect(formatter.call(severity, time, progname, exception)).to match(/\A#{PREFIX} error="Bad Error" file=oops line=123 function=nope\n\z/)
        end
      end

      context 'with no backtrace' do
        it 'logs the exception details in logfmt to the logger via info' do
          exception = Exception.new('Bad Error')
          expect(formatter.call(severity, time, progname, exception)).to match(/\A#{PREFIX} error="Bad Error"\n\z/)
        end
      end
    end
  end
end
