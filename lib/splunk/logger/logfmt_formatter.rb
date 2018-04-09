require 'time'

module Splunk
  class Logger
    class LogfmtFormatter
      Format = "severity=%s _time=%s pid=%d progname=%s %s\n".freeze

      class << self
        def from_hash(hash)
          raise ArgumentError, "#{hash} is not a Hash" unless hash.is_a?(Hash)
          hash
            .compact
            .collect { |key, value| "#{quote_if_needed(key.to_s)}=#{parse_value(value)}" }
            .join(' ')
        end

        def from_exception(ex)
          raise ArgumentError, "#{ex} is not an Exception" unless ex.is_a?(Exception)
          backtrace = (ex.backtrace || [])[0]
          /(?<filename>\w+):(?<line_number>\w+):in `(?<method_name>\w+)'/ =~ backtrace
          from_hash({ error: ex.message, file: filename, line: line_number, function: method_name })
        end

        def from_array(array)
          raise ArgumentError, "#{array} is not an Array" unless array.is_a?(Array)
          raise ArgumentError, "#{array} does not contain an even number of values" if array.length % 2 != 0
          from_hash(array.each_slice(2).to_h)
        end

        def quote_if_needed(str)
          str.include?(' ') ? str.inspect : str
        end

        def parse_value(value)
          raise ArgumentError, "#{value} is not a Symbol or String" unless value.is_a?(String) || value.is_a?(Symbol)
          quote_if_needed(value.to_s)
        end
      end

      def call(severity, time, progname, msg)
        Format % [severity, format_datetime(time), $$, (progname || 'splunk-logger'), msg2str(msg)]
      end

      private

      def format_datetime(time)
        time.iso8601
      end

      def msg2str(msg)
        case msg
        when ::Hash
          LogfmtFormatter.from_hash(msg)
        when ::Exception
          LogfmtFormatter.from_exception(msg)
        when ::Array
          LogfmtFormatter.from_array(msg)
        else
          raise ArgumentError, "This formatter only accepts Hashes, Arrays, and Exceptions"
        end
      end
    end
  end
end
