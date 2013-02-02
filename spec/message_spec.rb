require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SPNetwork::Message do
  describe '.new' do
    it 'should set data and type' do
      message = SPNetwork::Message.new :type => SPNetwork::Message::CONTROL, :data => 9
      message.type.should eq(SPNetwork::Message::CONTROL)
      message.data.should eq(9)
    end
  end
end
