require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::ExecCommandMessage do
  describe '.new' do
    it 'should set subtype to CommandMessage::EXEC' do
      message = SPNet::ExecCommandMessage.new 'do_this', 7
      message.subtype.should eq(SPNet::CommandMessage::EXEC)
    end

    it 'should set command' do
      message = SPNet::ExecCommandMessage.new 'do_this', 7
      message.command.should eq('do_this')
    end
    
    it 'should set data' do
      message = SPNet::ExecCommandMessage.new 'do_this', 7
      message.data.should eq(7)
    end
  end

end
