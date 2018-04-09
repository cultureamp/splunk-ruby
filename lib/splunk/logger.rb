require_relative 'logger/logfmt_formatter'

module Splunk
  class Logger
    def initialize(logger)
      @logger = logger
      @logger.formatter = LogfmtFormatter.new
    end

    def log(data)
      @logger.info(data)
    end
  end
end
