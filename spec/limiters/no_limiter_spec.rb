require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::NoLimiter do
  describe '.new' do
    it 'should always return the given value' do
      limiter = NoLimiter.new
      [-1, 1, Float::MAX, Float::MIN, "horse"].each do |value|
        value.should eq(limiter.limit_value(value))
      end
    end
  end
end
