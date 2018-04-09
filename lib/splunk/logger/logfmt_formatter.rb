require 'time'

module Splunk
  class Logger
    class LogfmtFormatter
      Format = "severity=%s _time=%s pid=%d progname=%s %s\n".freeze

      attr_accessor :datetime_format

      def initialize
        @datetime_format = nil
      end

      def call(severity, time, progname, msg)
        Format % [severity, format_datetime(time), $$, progname,
          msg2str(msg)]
      end

      private

      def format_datetime(time)
        time.iso8601
      end

      def msg2str(msg)
        case msg
        when ::Hash
          msg.collect { |key, value| "#{quote_if_needed(key.to_s)}=#{quote_if_needed(value.to_s)}" }.join(' ')
        when ::String
          msg.split('=').size == 1 ? "message=#{quote_if_needed(msg.to_s)}" : msg
        when ::Exception
          backtrace = (msg.backtrace || [])[0]
          /(?<filename>\w+):(?<line_number>\w+):in `(?<method_name>\w+)'/ =~ backtrace
          new_msg = { error: msg.message, file: filename, line: line_number, function: method_name }.compact
          msg2str(new_msg)
        when ::DateTime, ::Time
          "datetime=#{format_datetime(msg)}"
        when ::Date
          "date=#{format_datetime(msg)}"
        when ::Array
          msg2str((msg.length % 2 != 0) ? msg.inspect : msg.each_slice(2).to_a.to_h)
        else
          msg.inspect
        end
      end

      def quote_if_needed(str)
        str.include?(' ') ? str.inspect : str
      end
    end
  end
end
