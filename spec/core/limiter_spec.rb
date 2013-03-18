require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::Limiter do
  it 'should raise NotImplementedError if apply_limit is called' do
    lambda { Limiter.new.apply_limit 5, 4 }.should raise_error(NotImplementedError)
  end
end
