require 'splunk/logger'
require 'logger'

RSpec.describe Splunk::Logger do
  describe '#log' do
    it 'logs to the logger with the info severity' do
      logger = Logger.new(STDOUT)
      splunk_logger = Splunk::Logger.new(logger)
      expect(logger).to receive(:info).with({ foo: 'bar' })
      splunk_logger.log({ foo: 'bar' })
    end
  end
end
