require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::PortLocater do
  describe '.new' do
    it 'should assign block and port name' do
      locater = PortLocater.new :block_name => "block_A", :port_name => "port_A"
      locater.block_name.should eq("block_A")
      locater.port_name.should eq("port_A")
    end
  end
end
