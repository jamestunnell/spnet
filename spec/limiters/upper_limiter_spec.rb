require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::UpperLimiter do  
  describe '.apply_limit' do
    context 'non-inclusive' do
      before :all do
        @upper = 1
        @limiter = UpperLimiter.new(@upper, false)
      end

      it 'should return the given value it it is below the upper limit' do
        ok_values = [@upper - Float::EPSILON, @upper / 2.0]
        limited_values = ok_values.map { |value| @limiter.apply_limit value }
        limited_values.should eq(ok_values)
      end
      
      it 'should return the upper limit + Float::EPSILON if the given value is at or below the upper limit' do
        bad_values = [@upper, @upper + Float::EPSILON, @upper * 2.0]
        limited_values = bad_values.map { |value| @limiter.apply_limit value }
        limited_values.each do |value|
          value.should eq(@upper - Float::EPSILON)
        end
      end
    end
    
    context 'inclusive upper limit, non-inclusive upper limit' do
      before :all do
        @upper = 1
        @limiter = UpperLimiter.new(@upper, true)
      end

      it 'should return the given value it it is at or below the upper limit' do
        ok_values = [@upper, @upper - Float::EPSILON, @upper / 2.0]
        limited_values = ok_values.map { |value| @limiter.apply_limit value }
        limited_values.should eq(ok_values)
      end
      
      it 'should return the upper limit if the given value is below the upper limit' do
        bad_values = [@upper + Float::EPSILON, @upper * 2.0]
        limited_values = bad_values.map { |value| @limiter.apply_limit value }
        limited_values.each do |value|
          value.should eq(@upper)
        end
      end
    end
  end
end
