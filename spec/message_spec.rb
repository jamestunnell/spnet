require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SPNet::Message do
  describe '.new' do
    it 'should set data and type' do
      message = SPNet::Message.new :type => SPNet::Message::CONTROL, :data => 9
      message.type.should eq(SPNet::Message::CONTROL)
      message.data.should eq(9)
    end
  end
end
