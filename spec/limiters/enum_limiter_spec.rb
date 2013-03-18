require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::EnumLimiter do
  describe '.new' do
    it 'should raise ArgumentError if non-Enumerable is given' do
      lambda { EnumLimiter.new(5) }.should raise_error(ArgumentError)
    end
  end
  
  describe '.apply_limit' do
    it 'should return the given value if it is contained in @values' do
      values = [1,3,5,7]
      limiter = EnumLimiter.new values
      values.each do |value|
        limiter.apply_limit(value, 0).should eq(value)
      end
    end
    
    it 'should return the given current_value if the given value is not contained in @values' do
      values = [1,3,5,7]
      non_values = [2,4,6,8]
      limiter = EnumLimiter.new values
      non_values.each do |value|
        limiter.apply_limit(value, 0).should eq(0)
      end
    end
  end
end
