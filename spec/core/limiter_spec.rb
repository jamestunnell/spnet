require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::Limiter do
  it 'should raise NotImplementedError if limit_value is called' do
    lambda { Limiter.new.limit_value 5, 4 }.should raise_error(NotImplementedError)
  end
end
