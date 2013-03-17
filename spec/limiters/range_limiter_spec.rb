require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::RangeLimiter do
  describe '.new' do
    it 'should raise ArgumentError if non-Limit is given' do
      lambda { EnumLimiter.new(4, Limit.new(5,true)) }.should raise_error(ArgumentError)
      lambda { EnumLimiter.new(Limit.new(5,true), 6) }.should raise_error(ArgumentError)
    end
  end
  
  describe '.limit_value' do
    context 'non-inclusive lower limit, non-inclusive upper limit' do
      before :all do
        @lower, @upper = 1, 3
        @limiter = RangeLimiter.new(Limit.new(@lower, false), Limit.new(@upper, false))
      end

      it 'should return the given value it it is above lower limit and below upper limit' do
        ok_values = [@lower + Float::EPSILON, (@lower + @upper) / 2.0, @upper - Float::EPSILON]
        limited_values = ok_values.map { |value| @limiter.limit_value value }
        limited_values.should eq(ok_values)
      end
      
      it 'should return the lower limit + Float::EPSILON if the given value is at or below the lower limit' do
        bad_values = [@lower, @lower - Float::EPSILON, @lower - 1]
        limited_values = bad_values.map { |value| @limiter.limit_value value }
        limited_values.each do |value|
          value.should eq(@lower + Float::EPSILON)
        end
      end

      it 'should return the upper limit - Float::EPSILON if the given value is at or above the upper limit' do
        bad_values = [@upper, @upper + Float::EPSILON, @upper + 1]
        limited_values = bad_values.map { |value| @limiter.limit_value value }
        limited_values.each do |value|
          value.should eq(@upper - Float::EPSILON)
        end
      end
    end
    
    context 'inclusive lower limit, non-inclusive upper limit' do
      before :all do
        @lower, @upper = 1, 3
        @limiter = RangeLimiter.new(Limit.new(@lower, true), Limit.new(@upper, false))
      end

      it 'should return the given value it it is at or above the lower limit and below the upper limit' do
        ok_values = [@lower, (@lower + @upper) / 2.0, @upper - Float::EPSILON]
        limited_values = ok_values.map { |value| @limiter.limit_value value }
        limited_values.should eq(ok_values)
      end
      
      it 'should return the lower limit if the given value is below the lower limit' do
        bad_values = [@lower - Float::EPSILON, @lower - 1]
        limited_values = bad_values.map { |value| @limiter.limit_value value }
        limited_values.each do |value|
          value.should eq(@lower)
        end
      end

      it 'should return the upper limit - Float::EPSILON if the given value is at or above the upper limit' do
        bad_values = [@upper, @upper + 1]
        limited_values = bad_values.map { |value| @limiter.limit_value value }
        limited_values.each do |value|
          value.should eq(@upper - Float::EPSILON)
        end
      end
    end

    context 'non-inclusive lower limit, inclusive upper limit' do
      before :all do
        @lower, @upper = 1, 3
        @limiter = RangeLimiter.new(Limit.new(@lower, false), Limit.new(@upper, true))
      end

      it 'should return the given value it it is above the lower limit and at or below the upper limit' do
        ok_values = [@lower + Float::EPSILON, (@lower + @upper) / 2.0, @upper]
        limited_values = ok_values.map { |value| @limiter.limit_value value }
        limited_values.should eq(ok_values)
      end
      
      it 'should return the lower limit + Float::EPSILON if the given value is at or below the lower limit' do
        bad_values = [@lower, @lower - Float::EPSILON, @lower - 1]
        limited_values = bad_values.map { |value| @limiter.limit_value value }
        limited_values.each do |value|
          value.should eq(@lower + Float::EPSILON)
        end
      end

      it 'should return the upper limit if the given value is above the upper limit' do
        bad_values = [@upper + Float::EPSILON, @upper + 1]
        limited_values = bad_values.map { |value| @limiter.limit_value value }
        limited_values.each do |value|
          value.should eq(@upper)
        end
      end
    end

    context 'inclusive lower limit, inclusive upper limit' do
      before :all do
        @lower, @upper = 1, 3
        @limiter = RangeLimiter.new(Limit.new(@lower, true), Limit.new(@upper, true))
      end

      it 'should return the given value it it is at or above the lower limit and at or below the upper limit' do
        ok_values = [@lower, (@lower + @upper) / 2.0, @upper]
        limited_values = ok_values.map { |value| @limiter.limit_value value }
        limited_values.should eq(ok_values)
      end

      it 'should return the lower limit if the given value is below the lower limit' do
        bad_values = [@lower - Float::EPSILON, @lower - 1]
        limited_values = bad_values.map { |value| @limiter.limit_value value }
        limited_values.each do |value|
          value.should eq(@lower)
        end
      end

      it 'should return the upper limit if the given value is above the upper limit' do
        bad_values = [@upper + Float::EPSILON, @upper + 1]
        limited_values = bad_values.map { |value| @limiter.limit_value value }
        limited_values.each do |value|
          value.should eq(@upper)
        end
      end
    end
  end
  
  describe '::make_range_limiter' do
    it 'should produce equivalent limiter' do
      [0..5, -2.2..5.6, -1000..2000].each do |range|
        [true,true,false,false].each do |include_start|
          [true,false,true,false].each do |include_end|
            
            start_bracket = include_start ? "[" : "("
            end_bracket = include_end ? "]" : ")"
            
            limiter = make_range_limiter("#{start_bracket} #{range.first}, #{range.last} #{end_bracket}")
            limiter2 = RangeLimiter.new(Limit.new(range.first,include_start), Limit.new(range.last, include_end))
            
            limiter.lower_limiter.limit.value.should eq(limiter2.lower_limiter.limit.value)
            limiter.lower_limiter.limit.inclusive.should eq(limiter2.lower_limiter.limit.inclusive)
            limiter.upper_limiter.limit.value.should eq(limiter2.upper_limiter.limit.value)
            limiter.upper_limiter.limit.inclusive.should eq(limiter2.upper_limiter.limit.inclusive)
          end
        end
      end
    end
  end
end
