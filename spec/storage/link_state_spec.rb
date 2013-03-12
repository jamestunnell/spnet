require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::LinkState do
  describe '.new' do
    it 'should assign from and to port locaters' do
      output = PortLocater.new :block_name => "block_A", :port_name => "OUT"
      input = PortLocater.new :block_name => "block_B", :port_name => "IN"
      link_state = LinkState.new :from => output, :to => input
      link_state.from.should eq(output)
      link_state.to.should eq(input)
    end
  end
  
  describe '#make_link' do
    it 'should make a Link object, given good blocks' do
      blocks = {
        "block_A" => TestBlock.new,
        "block_B" => TestBlock.new,
      }
      output = PortLocater.new :block_name => "block_A", :port_name => "OUT"
      input = PortLocater.new :block_name => "block_B", :port_name => "IN"
      link_state = LinkState.new :from => output, :to => input
      link = link_state.make_link blocks
      link.from.should eq blocks["block_A"].out_ports["OUT"]
      link.to.should eq blocks["block_B"].in_ports["IN"]
    end
  end
end
