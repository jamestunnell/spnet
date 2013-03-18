require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::LowerLimiter do
  describe '.apply_limit' do
    context 'non-inclusive' do
      before :all do
        @lower = 1
        @limiter = LowerLimiter.new(@lower, false)
      end

      it 'should return the given value it it is above lower limit' do
        ok_values = [@lower + Float::EPSILON, @lower * 2.0]
        limited_values = ok_values.map { |value| @limiter.apply_limit value }
        limited_values.should eq(ok_values)
      end
      
      it 'should return the lower limit + Float::EPSILON if the given value is at or below the lower limit' do
        bad_values = [@lower, @lower - Float::EPSILON, @lower / 2.0]
        limited_values = bad_values.map { |value| @limiter.apply_limit value }
        limited_values.each do |value|
          value.should eq(@lower + Float::EPSILON)
        end
      end
    end
    
    context 'inclusive lower limit, non-inclusive upper limit' do
      before :all do
        @lower = 1
        @limiter = LowerLimiter.new(@lower, true)
      end

      it 'should return the given value it it is at or above the lower limit' do
        ok_values = [@lower, @lower + Float::EPSILON, @lower * 2.0]
        limited_values = ok_values.map { |value| @limiter.apply_limit value }
        limited_values.should eq(ok_values)
      end
      
      it 'should return the lower limit if the given value is below the lower limit' do
        bad_values = [@lower - Float::EPSILON, @lower / 2.0]
        limited_values = bad_values.map { |value| @limiter.apply_limit value }
        limited_values.each do |value|
          value.should eq(@lower)
        end
      end
    end
  end

end
