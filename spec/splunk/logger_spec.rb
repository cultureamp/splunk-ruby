require 'splunk/logger'
require 'logger'

RSpec.describe Splunk::Logger do
  describe '#initialize' do
    it 'sets the logger instance var' do
      logger = Logger.new(STDOUT)
      splunk_logger = Splunk::Logger.new(logger)
      expect(splunk_logger.instance_variable_get(:@logger)).to eq logger
    end

    it 'sets the formatter for the logger' do
      logger = Logger.new(STDOUT)
      splunk_logger = Splunk::Logger.new(logger)
      expect(splunk_logger.instance_variable_get(:@logger).formatter).to be_an_instance_of(Splunk::Logger::LogfmtFormatter)
    end
  end

  describe '#log' do
    it 'logs to the logger with the info severity' do
      logger = Logger.new(STDOUT)
      splunk_logger = Splunk::Logger.new(logger)
      expect(logger).to receive(:info).with('foo')
      splunk_logger.log('foo')
    end
  end
end
