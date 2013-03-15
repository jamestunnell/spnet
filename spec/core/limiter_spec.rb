require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::Limit do
  it 'should set @value according to the given value' do
    limit = Limit.new 5, false
    limit.value.should eq(5)
    limit = Limit.new 4, false
    limit.value.should eq(4)
  end
  
  it 'should set @inclusive according to the given value' do
    limit = Limit.new 5, false
    limit.inclusive.should eq(false)
    limit = Limit.new 5, true
    limit.inclusive.should eq(true)
  end
end

describe SPNet::Limiter do
  it 'should raise NotImplementedError if limit_value is called' do
    lambda { Limiter.new.limit_value 5, 4 }.should raise_error(NotImplementedError)
  end
end
